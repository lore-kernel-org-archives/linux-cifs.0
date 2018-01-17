From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: remove redundant duplicated assignment of pointer
 'node'
Date: Wed, 17 Jan 2018 18:11:23 -0500 (EST)
Message-ID: <2031352942.702941.1516230683335.JavaMail.zimbra@redhat.com>
References: <20180117095239.10670-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117095239.10670-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


----- Original Message -----
From: "Colin King" <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: "Steve French" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Wednesday, 17 January, 2018 8:52:39 PM
Subject: [PATCH] cifs: remove redundant duplicated assignment of pointer 'node'

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Node is assigned twice to rb_first(root), first during declaration
time and second after a taking a spin lock, so we have a duplicated
assignment.  Remove the first assignment because it is redundant and
also not protected by the spin lock.

Cleans up clang warning:
fs/cifs/connect.c:4435:18: warning: Value stored to 'node' during
its initialization is never read

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0efd22e75ac7..63c5d85fe25e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4432,7 +4432,7 @@ cifs_prune_tlinks(struct work_struct *work)
 	struct cifs_sb_info *cifs_sb = container_of(work, struct cifs_sb_info,
 						    prune_tlinks.work);
 	struct rb_root *root = &cifs_sb->tlink_tree;
-	struct rb_node *node = rb_first(root);
+	struct rb_node *node;
 	struct rb_node *tmp;
 	struct tcon_link *tlink;
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
