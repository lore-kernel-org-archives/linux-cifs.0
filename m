From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] [SMB3] Add mfsymlinks support for SMB2.1/SMB3. Part 2
 query symlink
Date: Tue, 16 Sep 2014 01:05:49 -0500
Message-ID: <CAH2r5muC3a2Cb_8t1nFJDRsyf27q2T4jbddZ2vADBhAStSm0CQ@mail.gmail.com>
References: <CAH2r5muq3DYtwtpwTi-ezG7goeOYBLLkO_Nwfdt_2pmT-o0LCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113a6d1e3e93df0503288c68
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muq3DYtwtpwTi-ezG7goeOYBLLkO_Nwfdt_2pmT-o0LCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--001a113a6d1e3e93df0503288c68
Content-Type: text/plain; charset=UTF-8

Updated version of th3 final patch in series attached (which adds
query symlink support for smb2.1/smb3).  Makes minor correction to
error handling (SMB2_close call was in wrong place in some error
cases)



On Mon, Sep 15, 2014 at 6:39 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>     Adds support on SMB2.1 and SMB3 mounts for emulation of symlinks
>     via the "Minshall/French" symlink format already used for cifs
>     mounts when mfsymlinks mount option is used (and also used by Apple).
>     http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks
>     This second patch adds support to query them (recognize them as symlinks
>     and read them).
>
>     Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     CC: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/link.c      | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2ops.c   |  2 ++
>  fs/cifs/smb2proto.h |  4 ++++
>  3 files changed, 71 insertions(+)
>
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 11657f6..cf1113e 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -399,6 +399,71 @@ cifs_create_mf_symlink(unsigned int xid, struct
> cifs_tcon *tcon,
>      return rc;
>  }
>
> +/*
> + * SMB 2.1/SMB3 Protocol specific functions
> + */
> +
> +int
> +smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> +              struct cifs_sb_info *cifs_sb, const unsigned char *path,
> +              char *pbuf, unsigned int *pbytes_read)
> +{
> +    int rc;
> +    struct cifs_fid fid;
> +    struct cifs_open_parms oparms;
> +    struct cifs_io_parms io_parms;
> +    int buf_type = CIFS_NO_BUFFER;
> +    __le16 *utf16_path;
> +    __u8 oplock = SMB2_OPLOCK_LEVEL_II;
> +    struct smb2_file_all_info *pfile_info = NULL;
> +
> +    oparms.tcon = tcon;
> +    oparms.cifs_sb = cifs_sb;
> +    oparms.desired_access = GENERIC_READ;
> +    oparms.create_options = CREATE_NOT_DIR;
> +    if (backup_cred(cifs_sb))
> +        oparms.create_options |= CREATE_OPEN_BACKUP_INTENT;
> +    oparms.disposition = FILE_OPEN;
> +    oparms.fid = &fid;
> +    oparms.reconnect = false;
> +
> +    utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> +    if (utf16_path == NULL)
> +        return -ENOMEM;
> +
> +    pfile_info = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
> +                 GFP_KERNEL);
> +
> +    if (pfile_info == NULL) {
> +        rc = -ENOMEM;
> +        goto qmf_out;
> +    }
> +
> +    rc = SMB2_open(xid, &oparms, utf16_path, &oplock, pfile_info, NULL);
> +    if (rc)
> +        goto qmf_out;
> +
> +    if (pfile_info->EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
> +        /* it's not a symlink */
> +        rc = -ENOENT; /* Is there a better rc to return? */
> +        goto qmf_out;
> +    }
> +
> +    io_parms.netfid = fid.netfid;
> +    io_parms.pid = current->tgid;
> +    io_parms.tcon = tcon;
> +    io_parms.offset = 0;
> +    io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
> +    io_parms.persistent_fid = fid.persistent_fid;
> +    io_parms.volatile_fid = fid.volatile_fid;
> +    rc = SMB2_read(xid, &io_parms, pbytes_read, &pbuf, &buf_type);
> +qmf_out:
> +    kfree(utf16_path);
> +    kfree(pfile_info);
> +    SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> +    return rc;
> +}
> +
>  int
>  smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>                 struct cifs_sb_info *cifs_sb, const unsigned char *path,
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 7d3fa29..489f48b 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1452,6 +1452,7 @@ struct smb_version_operations smb21_operations = {
>      .rename = smb2_rename_path,
>      .create_hardlink = smb2_create_hardlink,
>      .query_symlink = smb2_query_symlink,
> +    .query_mf_symlink = smb3_query_mf_symlink,
>      .create_mf_symlink = smb3_create_mf_symlink,
>      .open = smb2_open_file,
>      .set_fid = smb2_set_fid,
> @@ -1532,6 +1533,7 @@ struct smb_version_operations smb30_operations = {
>      .rename = smb2_rename_path,
>      .create_hardlink = smb2_create_hardlink,
>      .query_symlink = smb2_query_symlink,
> +    .query_mf_symlink = smb3_query_mf_symlink,
>      .create_mf_symlink = smb3_create_mf_symlink,
>      .open = smb2_open_file,
>      .set_fid = smb2_set_fid,
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index e144ecf..79dc650 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -85,6 +85,10 @@ extern int smb2_create_hardlink(const unsigned int
> xid, struct cifs_tcon *tcon,
>  extern int smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>              struct cifs_sb_info *cifs_sb, const unsigned char *path,
>              char *pbuf, unsigned int *pbytes_written);
> +extern int smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> +              struct cifs_sb_info *cifs_sb,
> +              const unsigned char *path, char *pbuf,
> +              unsigned int *pbytes_read);
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

--001a113a6d1e3e93df0503288c68
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-SMB3-mfsymlinks-support-for-SMB2.1-SMB3.-Part-2-quer.patch"
Content-Disposition: attachment;
	filename="0001-SMB3-mfsymlinks-support-for-SMB2.1-SMB3.-Part-2-quer.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i04u6n9a0

RnJvbSBkNDQ5M2Y0ZTNjODZhYWJmOWM5NDcxN2Y4Nzc2M2QxM2VjNDMxMzk0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogVHVlLCAxNiBTZXAgMjAxNCAwMDo1ODoyNiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtTTUIz
XSBtZnN5bWxpbmtzIHN1cHBvcnQgZm9yIFNNQjIuMS9TTUIzLiBQYXJ0IDIgcXVlcnkKIHN5bWxp
bmsKCiAgICBBZGRzIHN1cHBvcnQgb24gU01CMi4xIGFuZCBTTUIzIG1vdW50cyBmb3IgZW11bGF0
aW9uIG9mIHN5bWxpbmtzCiAgICB2aWEgdGhlICJNaW5zaGFsbC9GcmVuY2giIHN5bWxpbmsgZm9y
bWF0IGFscmVhZHkgdXNlZCBmb3IgY2lmcwogICAgbW91bnRzIHdoZW4gbWZzeW1saW5rcyBtb3Vu
dCBvcHRpb24gaXMgdXNlZCAoYW5kIGFsc28gdXNlZCBieSBBcHBsZSkuCiAgICBodHRwOi8vd2lr
aS5zYW1iYS5vcmcvaW5kZXgucGhwL1VOSVhfRXh0ZW5zaW9ucyNNaW5zaGFsbC4yQkZyZW5jaF9z
eW1saW5rcwogICAgVGhpcyBzZWNvbmQgcGF0Y2ggYWRkcyBzdXBwb3J0IHRvIHF1ZXJ5IHRoZW0g
KHJlY29nbml6ZSB0aGVtIGFzIHN5bWxpbmtzCiAgICBhbmQgcmVhZCB0aGVtKS4gIFNlY29uZCB2
ZXJzaW9uIG9mIHBhdGNoIG1ha2VzIG1pbm9yIGNvcnJlY3Rpb24KICAgIHRvIGVycm9yIGhhbmRs
aW5nLgoKICAgIFNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29t
PgogICAgQ0M6IFN0ZWZhbiBNZXR6bWFjaGVyIDxtZXR6ZUBzYW1iYS5vcmc+Ci0tLQogZnMvY2lm
cy9saW5rLmMgICAgICB8IDY1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrCiBmcy9jaWZzL3NtYjJvcHMuYyAgIHwgIDIgKysKIGZzL2NpZnMvc21i
MnByb3RvLmggfCAgNCArKysrCiAzIGZpbGVzIGNoYW5nZWQsIDcxIGluc2VydGlvbnMoKykKCmRp
ZmYgLS1naXQgYS9mcy9jaWZzL2xpbmsuYyBiL2ZzL2NpZnMvbGluay5jCmluZGV4IDExNjU3ZjYu
LmRlM2RhZDggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvbGluay5jCisrKyBiL2ZzL2NpZnMvbGluay5j
CkBAIC0zOTksNiArMzk5LDcxIEBAIGNpZnNfY3JlYXRlX21mX3N5bWxpbmsodW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAlyZXR1cm4gcmM7CiB9CiAKKy8qCisgKiBT
TUIgMi4xL1NNQjMgUHJvdG9jb2wgc3BlY2lmaWMgZnVuY3Rpb25zCisgKi8KKworaW50CitzbWIz
X3F1ZXJ5X21mX3N5bWxpbmsodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNv
biwKKwkJICAgICAgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgY29uc3QgdW5zaWduZWQg
Y2hhciAqcGF0aCwKKwkJICAgICAgY2hhciAqcGJ1ZiwgdW5zaWduZWQgaW50ICpwYnl0ZXNfcmVh
ZCkKK3sKKwlpbnQgcmM7CisJc3RydWN0IGNpZnNfZmlkIGZpZDsKKwlzdHJ1Y3QgY2lmc19vcGVu
X3Bhcm1zIG9wYXJtczsKKwlzdHJ1Y3QgY2lmc19pb19wYXJtcyBpb19wYXJtczsKKwlpbnQgYnVm
X3R5cGUgPSBDSUZTX05PX0JVRkZFUjsKKwlfX2xlMTYgKnV0ZjE2X3BhdGg7CisJX191OCBvcGxv
Y2sgPSBTTUIyX09QTE9DS19MRVZFTF9JSTsKKwlzdHJ1Y3Qgc21iMl9maWxlX2FsbF9pbmZvICpw
ZmlsZV9pbmZvID0gTlVMTDsKKworCW9wYXJtcy50Y29uID0gdGNvbjsKKwlvcGFybXMuY2lmc19z
YiA9IGNpZnNfc2I7CisJb3Bhcm1zLmRlc2lyZWRfYWNjZXNzID0gR0VORVJJQ19SRUFEOworCW9w
YXJtcy5jcmVhdGVfb3B0aW9ucyA9IENSRUFURV9OT1RfRElSOworCWlmIChiYWNrdXBfY3JlZChj
aWZzX3NiKSkKKwkJb3Bhcm1zLmNyZWF0ZV9vcHRpb25zIHw9IENSRUFURV9PUEVOX0JBQ0tVUF9J
TlRFTlQ7CisJb3Bhcm1zLmRpc3Bvc2l0aW9uID0gRklMRV9PUEVOOworCW9wYXJtcy5maWQgPSAm
ZmlkOworCW9wYXJtcy5yZWNvbm5lY3QgPSBmYWxzZTsKKworCXV0ZjE2X3BhdGggPSBjaWZzX2Nv
bnZlcnRfcGF0aF90b191dGYxNihwYXRoLCBjaWZzX3NiKTsKKwlpZiAodXRmMTZfcGF0aCA9PSBO
VUxMKQorCQlyZXR1cm4gLUVOT01FTTsKKworCXBmaWxlX2luZm8gPSBremFsbG9jKHNpemVvZihz
dHJ1Y3Qgc21iMl9maWxlX2FsbF9pbmZvKSArIFBBVEhfTUFYICogMiwKKwkJCSAgICAgR0ZQX0tF
Uk5FTCk7CisKKwlpZiAocGZpbGVfaW5mbyA9PSBOVUxMKSB7CisJCXJjID0gLUVOT01FTTsKKwkJ
Z290byBxbWZfb3V0OworCX0KKworCXJjID0gU01CMl9vcGVuKHhpZCwgJm9wYXJtcywgdXRmMTZf
cGF0aCwgJm9wbG9jaywgcGZpbGVfaW5mbywgTlVMTCk7CisJaWYgKHJjKQorCQlnb3RvIHFtZl9v
dXQ7CisKKwlpZiAocGZpbGVfaW5mby0+RW5kT2ZGaWxlICE9IGNwdV90b19sZTY0KENJRlNfTUZf
U1lNTElOS19GSUxFX1NJWkUpKSB7CisJCS8qIGl0J3Mgbm90IGEgc3ltbGluayAqLworCQlyYyA9
IC1FTk9FTlQ7IC8qIElzIHRoZXJlIGEgYmV0dGVyIHJjIHRvIHJldHVybj8gKi8KKwkJZ290byBx
bWZfb3V0OworCX0KKworCWlvX3Bhcm1zLm5ldGZpZCA9IGZpZC5uZXRmaWQ7CisJaW9fcGFybXMu
cGlkID0gY3VycmVudC0+dGdpZDsKKwlpb19wYXJtcy50Y29uID0gdGNvbjsKKwlpb19wYXJtcy5v
ZmZzZXQgPSAwOworCWlvX3Bhcm1zLmxlbmd0aCA9IENJRlNfTUZfU1lNTElOS19GSUxFX1NJWkU7
CisJaW9fcGFybXMucGVyc2lzdGVudF9maWQgPSBmaWQucGVyc2lzdGVudF9maWQ7CisJaW9fcGFy
bXMudm9sYXRpbGVfZmlkID0gZmlkLnZvbGF0aWxlX2ZpZDsKKwlyYyA9IFNNQjJfcmVhZCh4aWQs
ICZpb19wYXJtcywgcGJ5dGVzX3JlYWQsICZwYnVmLCAmYnVmX3R5cGUpOworCVNNQjJfY2xvc2Uo
eGlkLCB0Y29uLCBmaWQucGVyc2lzdGVudF9maWQsIGZpZC52b2xhdGlsZV9maWQpOworcW1mX291
dDoKKwlrZnJlZSh1dGYxNl9wYXRoKTsKKwlrZnJlZShwZmlsZV9pbmZvKTsKKwlyZXR1cm4gcmM7
Cit9CisKIGludAogc21iM19jcmVhdGVfbWZfc3ltbGluayh1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAogCQkgICAgICAgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19z
YiwgY29uc3QgdW5zaWduZWQgY2hhciAqcGF0aCwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9w
cy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggN2QzZmEyOS4uNDg5ZjQ4YiAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTE0NTIsNiAr
MTQ1Miw3IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjIxX29wZXJhdGlvbnMg
PSB7CiAJLnJlbmFtZSA9IHNtYjJfcmVuYW1lX3BhdGgsCiAJLmNyZWF0ZV9oYXJkbGluayA9IHNt
YjJfY3JlYXRlX2hhcmRsaW5rLAogCS5xdWVyeV9zeW1saW5rID0gc21iMl9xdWVyeV9zeW1saW5r
LAorCS5xdWVyeV9tZl9zeW1saW5rID0gc21iM19xdWVyeV9tZl9zeW1saW5rLAogCS5jcmVhdGVf
bWZfc3ltbGluayA9IHNtYjNfY3JlYXRlX21mX3N5bWxpbmssCiAJLm9wZW4gPSBzbWIyX29wZW5f
ZmlsZSwKIAkuc2V0X2ZpZCA9IHNtYjJfc2V0X2ZpZCwKQEAgLTE1MzIsNiArMTUzMyw3IEBAIHN0
cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjMwX29wZXJhdGlvbnMgPSB7CiAJLnJlbmFt
ZSA9IHNtYjJfcmVuYW1lX3BhdGgsCiAJLmNyZWF0ZV9oYXJkbGluayA9IHNtYjJfY3JlYXRlX2hh
cmRsaW5rLAogCS5xdWVyeV9zeW1saW5rID0gc21iMl9xdWVyeV9zeW1saW5rLAorCS5xdWVyeV9t
Zl9zeW1saW5rID0gc21iM19xdWVyeV9tZl9zeW1saW5rLAogCS5jcmVhdGVfbWZfc3ltbGluayA9
IHNtYjNfY3JlYXRlX21mX3N5bWxpbmssCiAJLm9wZW4gPSBzbWIyX29wZW5fZmlsZSwKIAkuc2V0
X2ZpZCA9IHNtYjJfc2V0X2ZpZCwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnByb3RvLmggYi9m
cy9jaWZzL3NtYjJwcm90by5oCmluZGV4IGUxNDRlY2YuLjc5ZGM2NTAgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvc21iMnByb3RvLmgKKysrIGIvZnMvY2lmcy9zbWIycHJvdG8uaApAQCAtODUsNiArODUs
MTAgQEAgZXh0ZXJuIGludCBzbWIyX2NyZWF0ZV9oYXJkbGluayhjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogZXh0ZXJuIGludCBzbWIzX2NyZWF0ZV9tZl9z
eW1saW5rKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQlzdHJ1
Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLCBjb25zdCB1bnNpZ25lZCBjaGFyICpwYXRoLAogCQkJ
Y2hhciAqcGJ1ZiwgdW5zaWduZWQgaW50ICpwYnl0ZXNfd3JpdHRlbik7CitleHRlcm4gaW50IHNt
YjNfcXVlcnlfbWZfc3ltbGluayh1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAorCQkJICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAorCQkJICBjb25zdCB1bnNp
Z25lZCBjaGFyICpwYXRoLCBjaGFyICpwYnVmLAorCQkJICB1bnNpZ25lZCBpbnQgKnBieXRlc19y
ZWFkKTsKIGV4dGVybiBpbnQgc21iMl9vcGVuX2ZpbGUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwK
IAkJCSAgc3RydWN0IGNpZnNfb3Blbl9wYXJtcyAqb3Bhcm1zLAogCQkJICBfX3UzMiAqb3Bsb2Nr
LCBGSUxFX0FMTF9JTkZPICpidWYpOwotLSAKMS45LjEKCg==
--001a113a6d1e3e93df0503288c68--
