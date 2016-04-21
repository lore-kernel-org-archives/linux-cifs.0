From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Design of fsnotify for FUSE, nfs and cifs: when/how to send a watch.
Date: Thu, 21 Apr 2016 09:10:25 +0200
Message-ID: <CANXojcz-U4YzgUhDRgvoVX=n756oVg4nvvvwpimmpBJyLkkmoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

we've had earlier contact about making fsnotify work with cifs, FUSE
and nfs (and others).

It still was something I want to work on, and now I've got some
patches, and got it working for FUSE.
I had to patch fsnotify, the FUSE kernel module and the fuse library.

You can find some design notes on:

https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FUSE.

Globally it works like:

- when a watch is set on a FUSE fs AND the user has added the
IN_REMOTE flag in inotify_add_watch, fsnotify calls a FUSE specific
function to notify the userspace daemon a watch has been set  (data is
inonr and mask)
- this function in FUSE sends info about the watch to userspace
- the userspace daemon can ignore this, it can send the backend a
message to the backend to set a watch (like NT_TRANSACT_NOTIFY_CHANGE
with cifs).
- when the userspace daemon receives an event, it translates it back
and sends it to the FUSE kernel module. This was not too hard, FUSE
has already some calls to push information from userspace to the VFS,
and I've added here an extra call.
- when the VFS receives the info about an event, it calls a generic
function in fsnotify to report an event. Here I add the FS_REMOTE
(IN_REMOTE) to note to listning users it's and event on the backend.

Now at this moment I have some questions, to start with is:

- when should fsnotify send a watch to FUSE userspace?
I've the following patch for inode_mark.c in fs/notify below.
As you can see the function fsnotify_mark_fsbackend is called when the
mask changes.
It looks at the result of the mask and the supported events
(FS_BACKEND_EFF_MASK), and only if FS_REMOTE is set in the mask, it
calls a backend specific function to forward the watch.
So I'm using the FS_REMOTE flag in the mask, only if this is set
action is taken. Is this the way to go? It's also possible to add
config options in the kernel, simular to support for fs-cache. One
generic option under fsnotify, and an option with every filesystem. Or
adding an option to the mount command, and negotiation to enable
fsnotify at mount time?

Futher the patch tests a watch is set on a FUSE fs by looking at the
name of the superblock (it should be "fuse"). Is this a smart way or
are there better/less expensive ways?

Stef

[sbon@ws-001 kernel]$ cat forward_fsnotify_watch_fuse.patch
--- linux-stable/fs/notify/inode_mark.c.orig    2016-02-21
13:09:18.000000000 +0100
+++ linux-stable/fs/notify/inode_mark.c 2016-02-21 15:08:43.610867825 +0100
@@ -30,6 +30,49 @@

#include "../internal.h"

+#define FS_BACKEND_EFF_MASK (FS_ATTRIB | FS_MODIFY | FS_CREATE |
FS_DELETE | FS_MOVED_FROM | FS_MOVED_TO | FS_DELETE_SELF |
FS_MOVE_SELF | FS_EVENT_ON_CHILD | F
S_REMOTE)
+
+extern void fuse_send_fsnotify_mark(struct inode *inode, unsigned
char what, uint32_t mask);
+
+void fsnotify_mark_fsbackend(struct inode *inode, uint32_t prev_mask)
+{
+    uint32_t eff_prev_mask=prev_mask & FS_BACKEND_EFF_MASK;
+    uint32_t eff_new_mask=inode->i_fsnotify_mask & FS_BACKEND_EFF_MASK;
+
+    if (eff_prev_mask & FS_REMOTE) {
+
+       if (!(eff_new_mask & FS_REMOTE)) {
+
+           /*
+               FS_REMOTE removed from mask
+           */
+
+           if (strcmp(inode->i_sb->s_type->name, "fuse")==0)
fuse_send_fsnotify_mark(inode, 0, 0);
+
+       } else if (!(eff_prev_mask==eff_new_mask)) {
+
+           /* mask changed */
+
+           if (strcmp(inode->i_sb->s_type->name, "fuse")==0)
fuse_send_fsnotify_mark(inode, 1, eff_new_mask);
+
+       }
+
+    } else {
+
+       if (eff_new_mask & FS_REMOTE) {
+
+           /*
+               FS_REMOTE added to mask
+           */
+
+           if (strcmp(inode->i_sb->s_type->name, "fuse")==0)
fuse_send_fsnotify_mark(inode, 2, eff_new_mask);
+
+       }
+
+    }
+
+}
+
/*
 * Recalculate the inode->i_fsnotify_mask, or the mask of all FS_* event types
 * any notifier is interested in hearing for this inode.
@@ -46,6 +89,7 @@ void fsnotify_recalc_inode_mask(struct i
void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark)
{
       struct inode *inode = mark->inode;
+       uint32_t mask=inode->i_fsnotify_mask;

       BUG_ON(!mutex_is_locked(&mark->group->mark_mutex));
       assert_spin_locked(&mark->lock);
@@ -61,6 +105,9 @@ void fsnotify_destroy_inode_mark(struct
        * inode->i_fsnotify_mask
        */
       inode->i_fsnotify_mask = fsnotify_recalc_mask(&inode->i_fsnotify_marks);
+
+       if (mask != inode->i_fsnotify_mask)
fsnotify_mark_fsbackend(inode, mask);
+
       spin_unlock(&inode->i_lock);
}

@@ -125,6 +172,7 @@ int fsnotify_add_inode_mark(struct fsnot
                           int allow_dups)
{
       int ret;
+       uint32_t mask=inode->i_fsnotify_mask;

       mark->flags |= FSNOTIFY_MARK_FLAG_INODE;

@@ -136,6 +184,7 @@ int fsnotify_add_inode_mark(struct fsnot
       ret = fsnotify_add_mark_list(&inode->i_fsnotify_marks, mark,
                                    allow_dups);
       inode->i_fsnotify_mask = fsnotify_recalc_mask(&inode->i_fsnotify_marks);
+       if (mask != inode->i_fsnotify_mask)
fsnotify_mark_fsbackend(inode, mask);
       spin_unlock(&inode->i_lock);

       return ret;
