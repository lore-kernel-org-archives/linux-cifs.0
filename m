From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: vfs: move btrfs clone ioctls to common code
Date: Thu, 26 Nov 2015 19:50:54 +0100
Message-ID: <1448563859-21922-1-git-send-email-hch@lst.de>
Cc: tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch set moves the existing btrfs clone ioctls that other file
system have started to implement to common code, and allows the NFS
server to export this functionality to remote systems.

This work is based originally on my NFS CLONE prototype, which reused
code from Anna Schumaker's NFS COPY prototype, as well as various
updates from Peng Tao to this code.

The patches are also available as a git branch and on gitweb:

	git://git.infradead.org/users/hch/pnfs.git clone-for-viro
	http://git.infradead.org/users/hch/pnfs.git/shortlog/refs/heads/clone-for-viro
