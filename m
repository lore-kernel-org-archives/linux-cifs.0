From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: fs: Limit sys_mount to only request filesystem modules prevents mount -t cifs from working
Date: Mon, 11 Mar 2013 06:37:09 -0700
Message-ID: <87obeqnjlm.fsf@xmission.com>
References: <513DD49F.8010301@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
	Kees Cook <keescook@google.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513DD49F.8010301@internode.on.net> (Arthur Marsh's message of
	"Mon, 11 Mar 2013 23:27:03 +1030")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Arthur Marsh <arthur.marsh@internode.on.net> writes:

> Hi, I found that Linux kernel 3.9.0-rc2 would not mount a remote cifs
> filesystem, and ran a git bisect which identified the following
> commit:
>
> Is there a patch already present somewhere to fix this problem?
>

Grr.  It was in linux-next for nearly a week and I checked an double
checked that patch.

This should fix it. 

Eric


diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1a052c0..3cf8a15 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -777,6 +777,7 @@ struct file_system_type cifs_fs_type = {
 	.kill_sb = cifs_kill_sb,
 	/*  .fs_flags */
 };
+MODULE_ALIAS_FS("cifs");
 const struct inode_operations cifs_dir_inode_ops = {
 	.create = cifs_create,
 	.atomic_open = cifs_atomic_open,
