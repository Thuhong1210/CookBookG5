document.addEventListener('DOMContentLoaded', () => {
    initFollowButtons();
    initNotificationPanel();
});

function initFollowButtons() {
    const followButtons = document.querySelectorAll('[data-follow-btn]');
    if (!followButtons.length) {
        return;
    }

    const updateButton = (button, isFollowing) => {
        if (!button) {
            return;
        }
        button.dataset.following = isFollowing ? 'true' : 'false';
        button.classList.toggle('is-following', isFollowing);
        button.textContent = isFollowing ? 'Đang theo dõi' : 'Theo dõi';
    };

    followButtons.forEach((button) => {
        button.addEventListener('click', async (event) => {
            event.preventDefault();
            event.stopPropagation();

            if (button.dataset.loading === 'true') {
                return;
            }

            const userId = button.getAttribute('data-user-id');
            if (!userId) {
                return;
            }

            button.dataset.loading = 'true';
            const previousLabel = button.textContent;
            button.textContent = 'Đang xử lý...';

            try {
                const response = await fetch(`/user/${userId}/follow`, {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                });

                if (response.status === 401) {
                    window.location.href = '/login';
                    return;
                }

                const data = await response.json();
                if (data.success) {
                    updateButton(button, data.is_following);
                } else if (data.message) {
                    alert(data.message);
                }
            } catch (error) {
                console.error('Unable to toggle follow:', error);
                alert('Không thể cập nhật trạng thái theo dõi. Vui lòng thử lại.');
                button.textContent = previousLabel;
            } finally {
                delete button.dataset.loading;
                if (button.textContent === 'Đang xử lý...') {
                    updateButton(button, button.dataset.following === 'true');
                }
            }
        });
    });
}

function initNotificationPanel() {
    const panel = document.getElementById('notification-panel');
    const button = document.getElementById('notification-button');
    const badge = document.getElementById('notification-badge');
    const list = document.getElementById('notification-list');
    const emptyState = document.getElementById('notification-empty');
    const markAllButton = document.getElementById('mark-all-read');

    if (!panel || !button || !badge || !list || !emptyState) {
        return;
    }

    let isPanelOpen = false;
    let pollingTimer = null;

    const setBadgeCount = (count) => {
        if (count > 0) {
            badge.hidden = false;
            badge.textContent = count > 99 ? '99+' : count;
        } else {
            badge.hidden = true;
        }
    };

    const formatRelativeTime = (timestamp) => {
        const created = new Date(timestamp);
        const now = new Date();
        const diffMs = now - created;
        const diffMinutes = Math.floor(diffMs / 60000);
        if (diffMinutes < 1) {
            return 'Vừa xong';
        }
        if (diffMinutes < 60) {
            return `${diffMinutes} phút trước`;
        }
        const diffHours = Math.floor(diffMinutes / 60);
        if (diffHours < 24) {
            return `${diffHours} giờ trước`;
        }
        const diffDays = Math.floor(diffHours / 24);
        return `${diffDays} ngày trước`;
    };

    const renderNotifications = (notifications = []) => {
        list.innerHTML = '';
        if (!notifications.length) {
            emptyState.hidden = false;
            return;
        }
        emptyState.hidden = true;
        notifications.forEach((notification) => {
            const item = document.createElement('li');
            item.className = `notification-item${notification.is_read ? '' : ' unread'}`;

            const messageWrapper = document.createElement('div');
            messageWrapper.className = 'notification-message';

            const actorElement = document.createElement('strong');
            actorElement.textContent = notification.actor_name || 'Người dùng';
            messageWrapper.appendChild(actorElement);

            const messageText = notification.message || '';
            const messageSpan = document.createElement('span');
            messageSpan.textContent = messageText ? ` ${messageText}` : '';
            messageWrapper.appendChild(messageSpan);

            const metaWrapper = document.createElement('div');
            metaWrapper.className = 'notification-meta';

            if (notification.recipe_id) {
                const recipeLink = document.createElement('a');
                recipeLink.href = `/recipe/${notification.recipe_id}`;
                recipeLink.textContent = notification.recipe_title || 'Xem công thức';
                metaWrapper.appendChild(recipeLink);
            } else if (notification.recipe_title) {
                const recipeText = document.createElement('span');
                recipeText.className = 'notification-recipe';
                recipeText.textContent = notification.recipe_title;
                metaWrapper.appendChild(recipeText);
            }

            const timeSpan = document.createElement('span');
            const displayTime = notification.created_at_display || (notification.created_at ? formatRelativeTime(notification.created_at) : '');
            timeSpan.textContent = displayTime;

            metaWrapper.appendChild(timeSpan);

            item.appendChild(messageWrapper);
            item.appendChild(metaWrapper);
            list.appendChild(item);
        });
    };

    const fetchNotifications = async () => {
        try {
            const response = await fetch('/api/notifications');
            if (response.status === 401) {
                return;
            }
            const data = await response.json();
            if (data.success) {
                setBadgeCount(data.unread_count || 0);
                renderNotifications(data.notifications || []);
            }
        } catch (error) {
            console.error('Không thể tải thông báo:', error);
        }
    };

    const openPanel = () => {
        panel.classList.add('visible');
        isPanelOpen = true;
        fetchNotifications();
    };

    const closePanel = () => {
        panel.classList.remove('visible');
        isPanelOpen = false;
    };

    const togglePanel = () => {
        if (isPanelOpen) {
            closePanel();
        } else {
            openPanel();
        }
    };

    button.addEventListener('click', (event) => {
        event.preventDefault();
        event.stopPropagation();
        togglePanel();
    });

    document.addEventListener('click', (event) => {
        if (isPanelOpen && !panel.contains(event.target) && event.target !== button) {
            closePanel();
        }
    });

    if (markAllButton) {
        markAllButton.addEventListener('click', async () => {
            try {
                const response = await fetch('/api/notifications/mark-all', {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                });
                if (response.status === 401) {
                    window.location.href = '/login';
                    return;
                }
                const data = await response.json();
                if (data.success) {
                    setBadgeCount(0);
                    fetchNotifications();
                }
            } catch (error) {
                console.error('Không thể đánh dấu đã đọc:', error);
            }
        });
    }

    fetchNotifications();
    pollingTimer = setInterval(fetchNotifications, 30000);

    window.addEventListener('beforeunload', () => {
        if (pollingTimer) {
            clearInterval(pollingTimer);
        }
    });
}

