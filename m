From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [SMB3] Add mfsymlinks support for SMB2.1/SMB3. Part 1
 create symlink
Date: Tue, 16 Sep 2014 00:52:24 -0500
Message-ID: <CAH2r5muZNyC2eBxntmWE=dhb5-jnwCRpGqo9j1SacQvESs92CQ@mail.gmail.com>
References: <CAH2r5msPjpPvom=0G0-Sj3RdnXMRVJpXb=VBiRZ+E0RSqAPh6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113a6d1e41e92d0503285ca7
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msPjpPvom=0G0-Sj3RdnXMRVJpXb=VBiRZ+E0RSqAPh6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--001a113a6d1e41e92d0503285ca7
Content-Type: text/plain; charset=UTF-8

Resending patch series as attachments to avoid mailer issues



On Mon, Sep 15, 2014 at 1:39 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Adds support on SMB2.1 and SMB3 mounts for emulation of symlinks
> via the "Minshall/French" symlink format already used for cifs
> mounts when mfsymlinks mount option is used (and also used by Apple).
> http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks
> This first patch adds support to create them.  The next patch will
> add support for recognizing them and reading them.  Although CIFS/SMB3
> have other types of symlinks, in the many use cases they aren't
> practical (e.g. either require cifs only mounts with unix extensions
> to Samba, or require the user to be Administrator to Windows for SMB3).
> This also helps enable running additional xfstests over SMB3 (since some
> xfstests directly or indirectly require symlink support).
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/link.c      | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2ops.c   |  2 ++
>  fs/cifs/smb2proto.h |  4 +++-
>  3 files changed, 68 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index a5c2812..11657f6 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -28,6 +28,7 @@
>  #include "cifsproto.h"
>  #include "cifs_debug.h"
>  #include "cifs_fs_sb.h"
> +#include "smb2proto.h"
>
>  /*
>   * M-F Symlink Functions - Begin
> @@ -398,6 +399,68 @@ cifs_create_mf_symlink(unsigned int xid, struct
> cifs_tcon *tcon,
>      return rc;
>  }
>
> +int
> +smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> +               struct cifs_sb_info *cifs_sb, const unsigned char *path,
> +               char *pbuf, unsigned int *pbytes_written)
> +{
> +    int rc;
> +    struct cifs_fid fid;
> +    struct cifs_open_parms oparms;
> +    struct cifs_io_parms io_parms;
> +    int create_options = CREATE_NOT_DIR;
> +    __le16 *utf16_path;
> +    __u8 oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
> +    struct kvec iov[2];
> +
> +    if (backup_cred(cifs_sb))
> +        create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
> +    cifs_dbg(FYI, "%s: path: %s\n", __func__, path);
> +
> +    utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> +    if (!utf16_path)
> +        return -ENOMEM;
> +
> +    oparms.tcon = tcon;
> +    oparms.cifs_sb = cifs_sb;
> +    oparms.desired_access = GENERIC_WRITE;
> +    oparms.create_options = create_options;
> +    oparms.disposition = FILE_CREATE;
> +    oparms.fid = &fid;
> +    oparms.reconnect = false;
> +
> +    rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
> +    if (rc) {
> +        kfree(utf16_path);
> +        return rc;
> +    }
> +
> +    io_parms.netfid = fid.netfid;
> +    io_parms.pid = current->tgid;
> +    io_parms.tcon = tcon;
> +    io_parms.offset = 0;
> +    io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
> +    io_parms.persistent_fid = fid.persistent_fid;
> +    io_parms.volatile_fid = fid.volatile_fid;
> +
> +    /* iov[0] is reserved for smb header */
> +    iov[1].iov_base = pbuf;
> +    iov[1].iov_len = CIFS_MF_SYMLINK_FILE_SIZE;
> +
> +    rc = SMB2_write(xid, &io_parms, pbytes_written, iov, 1);
> +
> +    /* Make sure we wrote all of the symlink data */
> +    if ((rc == 0) && (*pbytes_written != CIFS_MF_SYMLINK_FILE_SIZE))
> +        rc = -EIO;
> +
> +    SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> +
> +    kfree(utf16_path);
> +    return rc;
> +}
> +
> +
>  /*
>   * M-F Symlink Functions - End
>   */
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index f522193..7d3fa29 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1452,6 +1452,7 @@ struct smb_version_operations smb21_operations = {
>      .rename = smb2_rename_path,
>      .create_hardlink = smb2_create_hardlink,
>      .query_symlink = smb2_query_symlink,
> +    .create_mf_symlink = smb3_create_mf_symlink,
>      .open = smb2_open_file,
>      .set_fid = smb2_set_fid,
>      .close = smb2_close_file,
> @@ -1531,6 +1532,7 @@ struct smb_version_operations smb30_operations = {
>      .rename = smb2_rename_path,
>      .create_hardlink = smb2_create_hardlink,
>      .query_symlink = smb2_query_symlink,
> +    .create_mf_symlink = smb3_create_mf_symlink,
>      .open = smb2_open_file,
>      .set_fid = smb2_set_fid,
>      .close = smb2_close_file,
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 67e8ce8..e144ecf 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -82,7 +82,9 @@ extern int smb2_rename_path(const unsigned int xid,
> struct cifs_tcon *tcon,
>  extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
>                  const char *from_name, const char *to_name,
>                  struct cifs_sb_info *cifs_sb);
> -
> +extern int smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> +            struct cifs_sb_info *cifs_sb, const unsigned char *path,
> +            char *pbuf, unsigned int *pbytes_written);
>  extern int smb2_open_file(const unsigned int xid,
>                struct cifs_open_parms *oparms,
>                __u32 *oplock, FILE_ALL_INFO *buf);
> --
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--001a113a6d1e41e92d0503285ca7
Content-Type: text/x-patch; charset=US-ASCII;
	name="0004-SMB3-Add-mfsymlinks-support-for-SMB2.1-SMB3.-Part-2-.patch"
Content-Disposition: attachment;
	filename="0004-SMB3-Add-mfsymlinks-support-for-SMB2.1-SMB3.-Part-2-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i04tptt70

RnJvbSA0MDljZGNlNjFlNDhkMTkyNzM3MjJlMzMxYTQyN2NkMTJhYTFjZWNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogTW9uLCAxNSBTZXAgMjAxNCAxODowNjoxNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggNC80XSBb
U01CM10gQWRkIG1mc3ltbGlua3Mgc3VwcG9ydCBmb3IgU01CMi4xL1NNQjMuICBQYXJ0IDIKIHF1
ZXJ5IHN5bWxpbmsKCiAgICBBZGRzIHN1cHBvcnQgb24gU01CMi4xIGFuZCBTTUIzIG1vdW50cyBm
b3IgZW11bGF0aW9uIG9mIHN5bWxpbmtzCiAgICB2aWEgdGhlICJNaW5zaGFsbC9GcmVuY2giIHN5
bWxpbmsgZm9ybWF0IGFscmVhZHkgdXNlZCBmb3IgY2lmcwogICAgbW91bnRzIHdoZW4gbWZzeW1s
aW5rcyBtb3VudCBvcHRpb24gaXMgdXNlZCAoYW5kIGFsc28gdXNlZCBieSBBcHBsZSkuCiAgICBo
dHRwOi8vd2lraS5zYW1iYS5vcmcvaW5kZXgucGhwL1VOSVhfRXh0ZW5zaW9ucyNNaW5zaGFsbC4y
QkZyZW5jaF9zeW1saW5rcwogICAgVGhpcyBzZWNvbmQgcGF0Y2ggYWRkcyBzdXBwb3J0IHRvIHF1
ZXJ5IHRoZW0gKHJlY29nbml6ZSB0aGVtIGFzIHN5bWxpbmtzCiAgICBhbmQgcmVhZCB0aGVtKS4K
CiAgICBTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KICAg
IENDOiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPgotLS0KIGZzL2NpZnMvbGlu
ay5jICAgICAgfCA2NSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKwogZnMvY2lmcy9zbWIyb3BzLmMgICB8ICAyICsrCiBmcy9jaWZzL3NtYjJwcm90
by5oIHwgIDQgKysrKwogMyBmaWxlcyBjaGFuZ2VkLCA3MSBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9saW5rLmMgYi9mcy9jaWZzL2xpbmsuYwppbmRleCAxMTY1N2Y2Li5jZjEx
MTNlIDEwMDY0NAotLS0gYS9mcy9jaWZzL2xpbmsuYworKysgYi9mcy9jaWZzL2xpbmsuYwpAQCAt
Mzk5LDYgKzM5OSw3MSBAQCBjaWZzX2NyZWF0ZV9tZl9zeW1saW5rKHVuc2lnbmVkIGludCB4aWQs
IHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJcmV0dXJuIHJjOwogfQogCisvKgorICogU01CIDIu
MS9TTUIzIFByb3RvY29sIHNwZWNpZmljIGZ1bmN0aW9ucworICovCisKK2ludAorc21iM19xdWVy
eV9tZl9zeW1saW5rKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCisJ
CSAgICAgIHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIGNvbnN0IHVuc2lnbmVkIGNoYXIg
KnBhdGgsCisJCSAgICAgIGNoYXIgKnBidWYsIHVuc2lnbmVkIGludCAqcGJ5dGVzX3JlYWQpCit7
CisJaW50IHJjOworCXN0cnVjdCBjaWZzX2ZpZCBmaWQ7CisJc3RydWN0IGNpZnNfb3Blbl9wYXJt
cyBvcGFybXM7CisJc3RydWN0IGNpZnNfaW9fcGFybXMgaW9fcGFybXM7CisJaW50IGJ1Zl90eXBl
ID0gQ0lGU19OT19CVUZGRVI7CisJX19sZTE2ICp1dGYxNl9wYXRoOworCV9fdTggb3Bsb2NrID0g
U01CMl9PUExPQ0tfTEVWRUxfSUk7CisJc3RydWN0IHNtYjJfZmlsZV9hbGxfaW5mbyAqcGZpbGVf
aW5mbyA9IE5VTEw7CisKKwlvcGFybXMudGNvbiA9IHRjb247CisJb3Bhcm1zLmNpZnNfc2IgPSBj
aWZzX3NiOworCW9wYXJtcy5kZXNpcmVkX2FjY2VzcyA9IEdFTkVSSUNfUkVBRDsKKwlvcGFybXMu
Y3JlYXRlX29wdGlvbnMgPSBDUkVBVEVfTk9UX0RJUjsKKwlpZiAoYmFja3VwX2NyZWQoY2lmc19z
YikpCisJCW9wYXJtcy5jcmVhdGVfb3B0aW9ucyB8PSBDUkVBVEVfT1BFTl9CQUNLVVBfSU5URU5U
OworCW9wYXJtcy5kaXNwb3NpdGlvbiA9IEZJTEVfT1BFTjsKKwlvcGFybXMuZmlkID0gJmZpZDsK
KwlvcGFybXMucmVjb25uZWN0ID0gZmFsc2U7CisKKwl1dGYxNl9wYXRoID0gY2lmc19jb252ZXJ0
X3BhdGhfdG9fdXRmMTYocGF0aCwgY2lmc19zYik7CisJaWYgKHV0ZjE2X3BhdGggPT0gTlVMTCkK
KwkJcmV0dXJuIC1FTk9NRU07CisKKwlwZmlsZV9pbmZvID0ga3phbGxvYyhzaXplb2Yoc3RydWN0
IHNtYjJfZmlsZV9hbGxfaW5mbykgKyBQQVRIX01BWCAqIDIsCisJCQkgICAgIEdGUF9LRVJORUwp
OworCisJaWYgKHBmaWxlX2luZm8gPT0gTlVMTCkgeworCQlyYyA9IC1FTk9NRU07CisJCWdvdG8g
cW1mX291dDsKKwl9CisKKwlyYyA9IFNNQjJfb3Blbih4aWQsICZvcGFybXMsIHV0ZjE2X3BhdGgs
ICZvcGxvY2ssIHBmaWxlX2luZm8sIE5VTEwpOworCWlmIChyYykKKwkJZ290byBxbWZfb3V0Owor
CisJaWYgKHBmaWxlX2luZm8tPkVuZE9mRmlsZSAhPSBjcHVfdG9fbGU2NChDSUZTX01GX1NZTUxJ
TktfRklMRV9TSVpFKSkgeworCQkvKiBpdCdzIG5vdCBhIHN5bWxpbmsgKi8KKwkJcmMgPSAtRU5P
RU5UOyAvKiBJcyB0aGVyZSBhIGJldHRlciByYyB0byByZXR1cm4/ICovCisJCWdvdG8gcW1mX291
dDsKKwl9CisKKwlpb19wYXJtcy5uZXRmaWQgPSBmaWQubmV0ZmlkOworCWlvX3Bhcm1zLnBpZCA9
IGN1cnJlbnQtPnRnaWQ7CisJaW9fcGFybXMudGNvbiA9IHRjb247CisJaW9fcGFybXMub2Zmc2V0
ID0gMDsKKwlpb19wYXJtcy5sZW5ndGggPSBDSUZTX01GX1NZTUxJTktfRklMRV9TSVpFOworCWlv
X3Bhcm1zLnBlcnNpc3RlbnRfZmlkID0gZmlkLnBlcnNpc3RlbnRfZmlkOworCWlvX3Bhcm1zLnZv
bGF0aWxlX2ZpZCA9IGZpZC52b2xhdGlsZV9maWQ7CisJcmMgPSBTTUIyX3JlYWQoeGlkLCAmaW9f
cGFybXMsIHBieXRlc19yZWFkLCAmcGJ1ZiwgJmJ1Zl90eXBlKTsKK3FtZl9vdXQ6CisJa2ZyZWUo
dXRmMTZfcGF0aCk7CisJa2ZyZWUocGZpbGVfaW5mbyk7CisJU01CMl9jbG9zZSh4aWQsIHRjb24s
IGZpZC5wZXJzaXN0ZW50X2ZpZCwgZmlkLnZvbGF0aWxlX2ZpZCk7CisJcmV0dXJuIHJjOworfQor
CiBpbnQKIHNtYjNfY3JlYXRlX21mX3N5bWxpbmsodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAkJICAgICAgIHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIGNv
bnN0IHVuc2lnbmVkIGNoYXIgKnBhdGgsCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBi
L2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IDdkM2ZhMjkuLjQ4OWY0OGIgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0xNDUyLDYgKzE0NTIs
NyBAQCBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyBzbWIyMV9vcGVyYXRpb25zID0gewog
CS5yZW5hbWUgPSBzbWIyX3JlbmFtZV9wYXRoLAogCS5jcmVhdGVfaGFyZGxpbmsgPSBzbWIyX2Ny
ZWF0ZV9oYXJkbGluaywKIAkucXVlcnlfc3ltbGluayA9IHNtYjJfcXVlcnlfc3ltbGluaywKKwku
cXVlcnlfbWZfc3ltbGluayA9IHNtYjNfcXVlcnlfbWZfc3ltbGluaywKIAkuY3JlYXRlX21mX3N5
bWxpbmsgPSBzbWIzX2NyZWF0ZV9tZl9zeW1saW5rLAogCS5vcGVuID0gc21iMl9vcGVuX2ZpbGUs
CiAJLnNldF9maWQgPSBzbWIyX3NldF9maWQsCkBAIC0xNTMyLDYgKzE1MzMsNyBAQCBzdHJ1Y3Qg
c21iX3ZlcnNpb25fb3BlcmF0aW9ucyBzbWIzMF9vcGVyYXRpb25zID0gewogCS5yZW5hbWUgPSBz
bWIyX3JlbmFtZV9wYXRoLAogCS5jcmVhdGVfaGFyZGxpbmsgPSBzbWIyX2NyZWF0ZV9oYXJkbGlu
aywKIAkucXVlcnlfc3ltbGluayA9IHNtYjJfcXVlcnlfc3ltbGluaywKKwkucXVlcnlfbWZfc3lt
bGluayA9IHNtYjNfcXVlcnlfbWZfc3ltbGluaywKIAkuY3JlYXRlX21mX3N5bWxpbmsgPSBzbWIz
X2NyZWF0ZV9tZl9zeW1saW5rLAogCS5vcGVuID0gc21iMl9vcGVuX2ZpbGUsCiAJLnNldF9maWQg
PSBzbWIyX3NldF9maWQsCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwcm90by5oIGIvZnMvY2lm
cy9zbWIycHJvdG8uaAppbmRleCBlMTQ0ZWNmLi43OWRjNjUwIDEwMDY0NAotLS0gYS9mcy9jaWZz
L3NtYjJwcm90by5oCisrKyBiL2ZzL2NpZnMvc21iMnByb3RvLmgKQEAgLTg1LDYgKzg1LDEwIEBA
IGV4dGVybiBpbnQgc21iMl9jcmVhdGVfaGFyZGxpbmsoY29uc3QgdW5zaWduZWQgaW50IHhpZCwg
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIGV4dGVybiBpbnQgc21iM19jcmVhdGVfbWZfc3ltbGlu
ayh1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJc3RydWN0IGNp
ZnNfc2JfaW5mbyAqY2lmc19zYiwgY29uc3QgdW5zaWduZWQgY2hhciAqcGF0aCwKIAkJCWNoYXIg
KnBidWYsIHVuc2lnbmVkIGludCAqcGJ5dGVzX3dyaXR0ZW4pOworZXh0ZXJuIGludCBzbWIzX3F1
ZXJ5X21mX3N5bWxpbmsodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwK
KwkJCSAgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKKwkJCSAgY29uc3QgdW5zaWduZWQg
Y2hhciAqcGF0aCwgY2hhciAqcGJ1ZiwKKwkJCSAgdW5zaWduZWQgaW50ICpwYnl0ZXNfcmVhZCk7
CiBleHRlcm4gaW50IHNtYjJfb3Blbl9maWxlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsCiAJCQkg
IHN0cnVjdCBjaWZzX29wZW5fcGFybXMgKm9wYXJtcywKIAkJCSAgX191MzIgKm9wbG9jaywgRklM
RV9BTExfSU5GTyAqYnVmKTsKLS0gCjEuOS4xCgo=
--001a113a6d1e41e92d0503285ca7
Content-Type: text/x-patch; charset=US-ASCII;
	name="0003-SMB3-Add-mfsymlinks-support-for-SMB2.1-SMB3.-Part-1-.patch"
Content-Disposition: attachment;
	filename="0003-SMB3-Add-mfsymlinks-support-for-SMB2.1-SMB3.-Part-1-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i04tpttm1

RnJvbSBmNTYzMDFlMzcwYjUzYTk2YTU5NTI4OWFiNTRkYWIzMzU3M2Y4MmNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogTW9uLCAxNSBTZXAgMjAxNCAwNDo0OToyOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMy80XSBb
U01CM10gQWRkIG1mc3ltbGlua3Mgc3VwcG9ydCBmb3IgU01CMi4xL1NNQjMuICBQYXJ0IDEKIGNy
ZWF0ZSBzeW1saW5rCgpBZGRzIHN1cHBvcnQgb24gU01CMi4xIGFuZCBTTUIzIG1vdW50cyBmb3Ig
ZW11bGF0aW9uIG9mIHN5bWxpbmtzCnZpYSB0aGUgIk1pbnNoYWxsL0ZyZW5jaCIgc3ltbGluayBm
b3JtYXQgYWxyZWFkeSB1c2VkIGZvciBjaWZzCm1vdW50cyB3aGVuIG1mc3ltbGlua3MgbW91bnQg
b3B0aW9uIGlzIHVzZWQgKGFuZCBhbHNvIHVzZWQgYnkgQXBwbGUpLgpodHRwOi8vd2lraS5zYW1i
YS5vcmcvaW5kZXgucGhwL1VOSVhfRXh0ZW5zaW9ucyNNaW5zaGFsbC4yQkZyZW5jaF9zeW1saW5r
cwpUaGlzIGZpcnN0IHBhdGNoIGFkZHMgc3VwcG9ydCB0byBjcmVhdGUgdGhlbS4gIFRoZSBuZXh0
IHBhdGNoIHdpbGwKYWRkIHN1cHBvcnQgZm9yIHJlY29nbml6aW5nIHRoZW0gYW5kIHJlYWRpbmcg
dGhlbS4gIEFsdGhvdWdoIENJRlMvU01CMwpoYXZlIG90aGVyIHR5cGVzIG9mIHN5bWxpbmtzLCBp
biB0aGUgbWFueSB1c2UgY2FzZXMgdGhleSBhcmVuJ3QKcHJhY3RpY2FsIChlLmcuIGVpdGhlciBy
ZXF1aXJlIGNpZnMgb25seSBtb3VudHMgd2l0aCB1bml4IGV4dGVuc2lvbnMKdG8gU2FtYmEsIG9y
IHJlcXVpcmUgdGhlIHVzZXIgdG8gYmUgQWRtaW5pc3RyYXRvciB0byBXaW5kb3dzIGZvciBTTUIz
KS4KVGhpcyBhbHNvIGhlbHBzIGVuYWJsZSBydW5uaW5nIGFkZGl0aW9uYWwgeGZzdGVzdHMgb3Zl
ciBTTUIzIChzaW5jZSBzb21lCnhmc3Rlc3RzIGRpcmVjdGx5IG9yIGluZGlyZWN0bHkgcmVxdWly
ZSBzeW1saW5rIHN1cHBvcnQpLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzbWZyZW5j
aEBnbWFpbC5jb20+CkNDOiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPgotLS0K
IGZzL2NpZnMvbGluay5jICAgICAgfCA2MyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKwogZnMvY2lmcy9zbWIyb3BzLmMgICB8ICAyICsrCiBmcy9j
aWZzL3NtYjJwcm90by5oIHwgIDQgKysrLQogMyBmaWxlcyBjaGFuZ2VkLCA2OCBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9saW5rLmMgYi9mcy9jaWZz
L2xpbmsuYwppbmRleCBhNWMyODEyLi4xMTY1N2Y2IDEwMDY0NAotLS0gYS9mcy9jaWZzL2xpbmsu
YworKysgYi9mcy9jaWZzL2xpbmsuYwpAQCAtMjgsNiArMjgsNyBAQAogI2luY2x1ZGUgImNpZnNw
cm90by5oIgogI2luY2x1ZGUgImNpZnNfZGVidWcuaCIKICNpbmNsdWRlICJjaWZzX2ZzX3NiLmgi
CisjaW5jbHVkZSAic21iMnByb3RvLmgiCiAKIC8qCiAgKiBNLUYgU3ltbGluayBGdW5jdGlvbnMg
LSBCZWdpbgpAQCAtMzk4LDYgKzM5OSw2OCBAQCBjaWZzX2NyZWF0ZV9tZl9zeW1saW5rKHVuc2ln
bmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJcmV0dXJuIHJjOwogfQogCitp
bnQKK3NtYjNfY3JlYXRlX21mX3N5bWxpbmsodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNf
dGNvbiAqdGNvbiwKKwkJICAgICAgIHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIGNvbnN0
IHVuc2lnbmVkIGNoYXIgKnBhdGgsCisJCSAgICAgICBjaGFyICpwYnVmLCB1bnNpZ25lZCBpbnQg
KnBieXRlc193cml0dGVuKQoreworCWludCByYzsKKwlzdHJ1Y3QgY2lmc19maWQgZmlkOworCXN0
cnVjdCBjaWZzX29wZW5fcGFybXMgb3Bhcm1zOworCXN0cnVjdCBjaWZzX2lvX3Bhcm1zIGlvX3Bh
cm1zOworCWludCBjcmVhdGVfb3B0aW9ucyA9IENSRUFURV9OT1RfRElSOworCV9fbGUxNiAqdXRm
MTZfcGF0aDsKKwlfX3U4IG9wbG9jayA9IFNNQjJfT1BMT0NLX0xFVkVMX0VYQ0xVU0lWRTsKKwlz
dHJ1Y3Qga3ZlYyBpb3ZbMl07CisKKwlpZiAoYmFja3VwX2NyZWQoY2lmc19zYikpCisJCWNyZWF0
ZV9vcHRpb25zIHw9IENSRUFURV9PUEVOX0JBQ0tVUF9JTlRFTlQ7CisKKwljaWZzX2RiZyhGWUks
ICIlczogcGF0aDogJXNcbiIsIF9fZnVuY19fLCBwYXRoKTsKKworCXV0ZjE2X3BhdGggPSBjaWZz
X2NvbnZlcnRfcGF0aF90b191dGYxNihwYXRoLCBjaWZzX3NiKTsKKwlpZiAoIXV0ZjE2X3BhdGgp
CisJCXJldHVybiAtRU5PTUVNOworCisJb3Bhcm1zLnRjb24gPSB0Y29uOworCW9wYXJtcy5jaWZz
X3NiID0gY2lmc19zYjsKKwlvcGFybXMuZGVzaXJlZF9hY2Nlc3MgPSBHRU5FUklDX1dSSVRFOwor
CW9wYXJtcy5jcmVhdGVfb3B0aW9ucyA9IGNyZWF0ZV9vcHRpb25zOworCW9wYXJtcy5kaXNwb3Np
dGlvbiA9IEZJTEVfQ1JFQVRFOworCW9wYXJtcy5maWQgPSAmZmlkOworCW9wYXJtcy5yZWNvbm5l
Y3QgPSBmYWxzZTsKKworCXJjID0gU01CMl9vcGVuKHhpZCwgJm9wYXJtcywgdXRmMTZfcGF0aCwg
Jm9wbG9jaywgTlVMTCwgTlVMTCk7CisJaWYgKHJjKSB7CisJCWtmcmVlKHV0ZjE2X3BhdGgpOwor
CQlyZXR1cm4gcmM7CisJfQorCisJaW9fcGFybXMubmV0ZmlkID0gZmlkLm5ldGZpZDsKKwlpb19w
YXJtcy5waWQgPSBjdXJyZW50LT50Z2lkOworCWlvX3Bhcm1zLnRjb24gPSB0Y29uOworCWlvX3Bh
cm1zLm9mZnNldCA9IDA7CisJaW9fcGFybXMubGVuZ3RoID0gQ0lGU19NRl9TWU1MSU5LX0ZJTEVf
U0laRTsKKwlpb19wYXJtcy5wZXJzaXN0ZW50X2ZpZCA9IGZpZC5wZXJzaXN0ZW50X2ZpZDsKKwlp
b19wYXJtcy52b2xhdGlsZV9maWQgPSBmaWQudm9sYXRpbGVfZmlkOworCisJLyogaW92WzBdIGlz
IHJlc2VydmVkIGZvciBzbWIgaGVhZGVyICovCisJaW92WzFdLmlvdl9iYXNlID0gcGJ1ZjsKKwlp
b3ZbMV0uaW92X2xlbiA9IENJRlNfTUZfU1lNTElOS19GSUxFX1NJWkU7CisKKwlyYyA9IFNNQjJf
d3JpdGUoeGlkLCAmaW9fcGFybXMsIHBieXRlc193cml0dGVuLCBpb3YsIDEpOworCisJLyogTWFr
ZSBzdXJlIHdlIHdyb3RlIGFsbCBvZiB0aGUgc3ltbGluayBkYXRhICovCisJaWYgKChyYyA9PSAw
KSAmJiAoKnBieXRlc193cml0dGVuICE9IENJRlNfTUZfU1lNTElOS19GSUxFX1NJWkUpKQorCQly
YyA9IC1FSU87CisKKwlTTUIyX2Nsb3NlKHhpZCwgdGNvbiwgZmlkLnBlcnNpc3RlbnRfZmlkLCBm
aWQudm9sYXRpbGVfZmlkKTsKKworCWtmcmVlKHV0ZjE2X3BhdGgpOworCXJldHVybiByYzsKK30K
KworCiAvKgogICogTS1GIFN5bWxpbmsgRnVuY3Rpb25zIC0gRW5kCiAgKi8KZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggZjUyMjE5My4uN2Qz
ZmEyOSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3Bz
LmMKQEAgLTE0NTIsNiArMTQ1Miw3IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNt
YjIxX29wZXJhdGlvbnMgPSB7CiAJLnJlbmFtZSA9IHNtYjJfcmVuYW1lX3BhdGgsCiAJLmNyZWF0
ZV9oYXJkbGluayA9IHNtYjJfY3JlYXRlX2hhcmRsaW5rLAogCS5xdWVyeV9zeW1saW5rID0gc21i
Ml9xdWVyeV9zeW1saW5rLAorCS5jcmVhdGVfbWZfc3ltbGluayA9IHNtYjNfY3JlYXRlX21mX3N5
bWxpbmssCiAJLm9wZW4gPSBzbWIyX29wZW5fZmlsZSwKIAkuc2V0X2ZpZCA9IHNtYjJfc2V0X2Zp
ZCwKIAkuY2xvc2UgPSBzbWIyX2Nsb3NlX2ZpbGUsCkBAIC0xNTMxLDYgKzE1MzIsNyBAQCBzdHJ1
Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyBzbWIzMF9vcGVyYXRpb25zID0gewogCS5yZW5hbWUg
PSBzbWIyX3JlbmFtZV9wYXRoLAogCS5jcmVhdGVfaGFyZGxpbmsgPSBzbWIyX2NyZWF0ZV9oYXJk
bGluaywKIAkucXVlcnlfc3ltbGluayA9IHNtYjJfcXVlcnlfc3ltbGluaywKKwkuY3JlYXRlX21m
X3N5bWxpbmsgPSBzbWIzX2NyZWF0ZV9tZl9zeW1saW5rLAogCS5vcGVuID0gc21iMl9vcGVuX2Zp
bGUsCiAJLnNldF9maWQgPSBzbWIyX3NldF9maWQsCiAJLmNsb3NlID0gc21iMl9jbG9zZV9maWxl
LApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycHJvdG8uaCBiL2ZzL2NpZnMvc21iMnByb3RvLmgK
aW5kZXggNjdlOGNlOC4uZTE0NGVjZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycHJvdG8uaAor
KysgYi9mcy9jaWZzL3NtYjJwcm90by5oCkBAIC04Miw3ICs4Miw5IEBAIGV4dGVybiBpbnQgc21i
Ml9yZW5hbWVfcGF0aChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAogZXh0ZXJuIGludCBzbWIyX2NyZWF0ZV9oYXJkbGluayhjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCWNvbnN0IGNoYXIgKmZyb21fbmFtZSwg
Y29uc3QgY2hhciAqdG9fbmFtZSwKIAkJCQlzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiKTsK
LQorZXh0ZXJuIGludCBzbWIzX2NyZWF0ZV9tZl9zeW1saW5rKHVuc2lnbmVkIGludCB4aWQsIHN0
cnVjdCBjaWZzX3Rjb24gKnRjb24sCisJCQlzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLCBj
b25zdCB1bnNpZ25lZCBjaGFyICpwYXRoLAorCQkJY2hhciAqcGJ1ZiwgdW5zaWduZWQgaW50ICpw
Ynl0ZXNfd3JpdHRlbik7CiBleHRlcm4gaW50IHNtYjJfb3Blbl9maWxlKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsCiAJCQkgIHN0cnVjdCBjaWZzX29wZW5fcGFybXMgKm9wYXJtcywKIAkJCSAgX191
MzIgKm9wbG9jaywgRklMRV9BTExfSU5GTyAqYnVmKTsKLS0gCjEuOS4xCgo=
--001a113a6d1e41e92d0503285ca7
Content-Type: text/x-patch; charset=US-ASCII;
	name="0002-SMB3-Fix-oops-when-creating-symlinks-on-smb3.patch"
Content-Disposition: attachment;
	filename="0002-SMB3-Fix-oops-when-creating-symlinks-on-smb3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i04tpttw2

RnJvbSBkYTgwNjU5ZDRhYTc1OGRjNjkzNWIxMGVjNjQ1MTNmMGI2N2JjOTY5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogU3VuLCAxNCBTZXAgMjAxNCAyMzoyNzowOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMi80XSBb
U01CM10gRml4IG9vcHMgd2hlbiBjcmVhdGluZyBzeW1saW5rcyBvbiBzbWIzCgpXZSB3ZXJlIG5v
dCBjaGVja2luZyBmb3Igc3ltbGluayBzdXBwb3J0IHByb3Blcmx5IGZvciBTTUIyL1NNQjMKbW91
bnRzIHNvIGNvdWxkIG9vcHMgd2hlbiBtb3VudGVkIHdpdGggbWZzeW1saW5rcyB3aGVuIHRyeQp0
byBjcmVhdGUgc3ltbGluayB3aGVuIG1mc3ltbGlua3Mgb24gc21iMi9zbWIzIG1vdW50cwoKU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+CkNjOiA8c3RhYmxl
QHZnZXIua2VybmVsLm9yZz4gIyAzLjE0KwpDQzogU2FjaGluIFByYWJodSA8c3ByYWJodUByZWRo
YXQuY29tPgotLS0KIGZzL2NpZnMvbGluay5jIHwgOCArKysrKystLQogMSBmaWxlIGNoYW5nZWQs
IDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2xp
bmsuYyBiL2ZzL2NpZnMvbGluay5jCmluZGV4IDY4NTU5ZmQuLmE1YzI4MTIgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvbGluay5jCisrKyBiL2ZzL2NpZnMvbGluay5jCkBAIC0yMTMsOCArMjEzLDEyIEBA
IGNyZWF0ZV9tZl9zeW1saW5rKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sCiAJaWYgKHJjKQogCQlnb3RvIG91dDsKIAotCXJjID0gdGNvbi0+c2VzLT5zZXJ2
ZXItPm9wcy0+Y3JlYXRlX21mX3N5bWxpbmsoeGlkLCB0Y29uLCBjaWZzX3NiLAotCQkJCQlmcm9t
TmFtZSwgYnVmLCAmYnl0ZXNfd3JpdHRlbik7CisJaWYgKHRjb24tPnNlcy0+c2VydmVyLT5vcHMt
PmNyZWF0ZV9tZl9zeW1saW5rKQorCQlyYyA9IHRjb24tPnNlcy0+c2VydmVyLT5vcHMtPmNyZWF0
ZV9tZl9zeW1saW5rKHhpZCwgdGNvbiwKKwkJCQkJY2lmc19zYiwgZnJvbU5hbWUsIGJ1ZiwgJmJ5
dGVzX3dyaXR0ZW4pOworCWVsc2UKKwkJcmMgPSAtRU9QTk9UU1VQUDsKKwogCWlmIChyYykKIAkJ
Z290byBvdXQ7CiAKLS0gCjEuOS4xCgo=
--001a113a6d1e41e92d0503285ca7--
