From: Vlastimil Babka <vbabka@suse.cz>
Subject: cifs buffer overflow in kernels before 3.7
Date: Thu, 12 Apr 2018 09:51:38 +0200
Message-ID: <86df41d8-80d8-a32c-69f8-f15b879c015d@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Jeff Layton <jlayton@redhat.com>
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi,

we have tracked down (in our 3.0-based kernel) a nasty overflow from
cifs_build_path_to_root() calling convert_delimiter() on a kmalloced
buffer that's not guaranteed to be null-terminated. AFAIU this happens
during mount of a share's subdirectory (vol->prepath is non-zero). This
was fixed (unknowingly) in 839db3d10a5b ("cifs: fix up handling of
prefixpath= option") in 3.7, so I believe there's at least the 3.2 LTS
affected. You could either backport the commit with followup fixes, or
do something like we did (below). Current mainline could also use
kzalloc() and move (or remove) the manual trailing null setting, as now
it maybe give false assurance to whoever will be modifying the code.

Vlastimil

-----8<-----
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] cifs: fix buffer overflow in cifs_build_path_to_root()

After the strncpy() in cifs_build_path_to_root(), there is no guarantee of a
trailing null, because pplen is initialized by strlen() which doesn't include
it. Then convert_delimiter() is called before the trailing null is added, which
means it can overflow the kmalloced object and corrupt unrelated memory until
it hits a null byte.

Make sure pplen includes the trailing null in vol->prepath. Also use kzalloc()
and add the trailing null (now redundant) before convert_delimiter().

Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 fs/cifs/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -792,7 +792,7 @@ static const struct inode_operations cif
 char *cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 			      struct cifs_tcon *tcon, int add_treename)
 {
-	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
+	int pplen = vol->prepath ? strlen(vol->prepath) + 1: 0;
 	int dfsplen;
 	char *full_path = NULL;
 
@@ -809,15 +809,15 @@ char *cifs_build_path_to_root(struct smb
 	else
 		dfsplen = 0;
 
-	full_path = kmalloc(dfsplen + pplen + 1, GFP_KERNEL);
+	full_path = kzalloc(dfsplen + pplen + 1, GFP_KERNEL);
 	if (full_path == NULL)
 		return full_path;
 
 	if (dfsplen)
 		strncpy(full_path, tcon->treeName, dfsplen);
 	strncpy(full_path + dfsplen, vol->prepath, pplen);
-	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
 	full_path[dfsplen + pplen] = 0; /* add trailing null */
+	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
 	return full_path;
 }
 
