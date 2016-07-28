From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix a possible invalid memory access in smb2_query_symlink()
Date: Thu, 28 Jul 2016 00:04:38 -0500
Message-ID: <CAH2r5mv6OmKbex9vQCxxVaoH25+=-HjShzfdUFonfhLspZay5A@mail.gmail.com>
References: <1469345858-5571-1-git-send-email-piastry@altlinux.org>
 <CAH2r5muh2_khdSDT55t1fTerm4qqY2jBaper-Eh9GtaAbX08zA@mail.gmail.com> <0C08296C-E9E7-431D-905A-B85D425814B8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0C08296C-E9E7-431D-905A-B85D425814B8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I lightly updated the patch to fix the endian warning and pushed to
cifs-2.6.git for-next

https://git.samba.org/?p=3Dsfrench/cifs-2.6.git;a=3Dcommitdiff;h=3D7893=
242e2465aea6f2cbc2639da8fa5ce96e8cc2

On Tue, Jul 26, 2016 at 2:00 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>
> 26 =D0=B8=D1=8E=D0=BB=D1=8F 2016 =D0=B3., =D0=B2 21:11, Steve French =
<smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0)=
:
>
> Line 1087 of smb2ops.c will throw a sparse warning due to endian prob=
lem
>
>
> Thanks for catching it! I will make a proper fix and resend the patch=
=2E
>
>
> On Sun, Jul 24, 2016 at 2:37 AM, Pavel Shilovsky <piastry-u2l5PoMzF/Upug/h7KTFAQ@public.gmane.org=
g>
> wrote:
>
> From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
>
> During following a symbolic link we received err_buf from SMB2_open()=
=2E
>
> While the validity of SMB2 error response is checked previously
>
> in smb2_check_message() a symbolic link payload is not checked at all=
=2E
>
> Fix it by adding such checks.
>
>
> Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
> ---
>
> fs/cifs/smb2ops.c | 30 +++++++++++++++++++++++++++++-
>
> 1 file changed, 29 insertions(+), 1 deletion(-)
>
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>
> index 527d1ac..9ec025c 100644
>
> --- a/fs/cifs/smb2ops.c
>
> +++ b/fs/cifs/smb2ops.c
>
> @@ -1044,6 +1044,9 @@ smb2_new_lease_key(struct cifs_fid *fid)
>
>        get_random_bytes(fid->lease_key, SMB2_LEASE_KEY_SIZE);
>
> }
>
>
> +#define SMB2_SYMLINK_STRUCT_SIZE \
>
> +       (sizeof(struct smb2_err_rsp) - 1 + sizeof(struct
> smb2_symlink_err_rsp))
>
> +
>
> static int
>
> smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>
>                   const char *full_path, char **target_path,
>
> @@ -1056,7 +1059,10 @@ smb2_query_symlink(const unsigned int xid, str=
uct
> cifs_tcon *tcon,
>
>        struct cifs_fid fid;
>
>        struct smb2_err_rsp *err_buf =3D NULL;
>
>        struct smb2_symlink_err_rsp *symlink;
>
> -       unsigned int sub_len, sub_offset;
>
> +       unsigned int sub_len;
>
> +       unsigned int sub_offset;
>
> +       unsigned int print_len;
>
> +       unsigned int print_offset;
>
>
>        cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
>
>
> @@ -1077,11 +1083,33 @@ smb2_query_symlink(const unsigned int xid, st=
ruct
> cifs_tcon *tcon,
>
>                kfree(utf16_path);
>
>                return -ENOENT;
>
>        }
>
> +
>
> +       if (err_buf->ByteCount < sizeof(struct smb2_symlink_err_rsp) =
||
>
> +           get_rfc1002_length(err_buf) + 4 < SMB2_SYMLINK_STRUCT_SIZ=
E) {
>
> +               kfree(utf16_path);
>
> +               return -ENOENT;
>
> +       }
>
> +
>
>        /* open must fail on symlink - reset rc */
>
>        rc =3D 0;
>
>        symlink =3D (struct smb2_symlink_err_rsp *)err_buf->ErrorData;
>
>        sub_len =3D le16_to_cpu(symlink->SubstituteNameLength);
>
>        sub_offset =3D le16_to_cpu(symlink->SubstituteNameOffset);
>
> +       print_len =3D le16_to_cpu(symlink->PrintNameLength);
>
> +       print_offset =3D le16_to_cpu(symlink->PrintNameOffset);
>
> +
>
> +       if (get_rfc1002_length(err_buf) + 4 <
>
> +                       SMB2_SYMLINK_STRUCT_SIZE + sub_offset + sub_l=
en) {
>
> +               kfree(utf16_path);
>
> +               return -ENOENT;
>
> +       }
>
> +
>
> +       if (get_rfc1002_length(err_buf) + 4 <
>
> +                       SMB2_SYMLINK_STRUCT_SIZE + print_offset + pri=
nt_len)
> {
>
> +               kfree(utf16_path);
>
> +               return -ENOENT;
>
> +       }
>
> +
>
>        *target_path =3D cifs_strndup_from_utf16(
>
>                                (char *)symlink->PathBuffer + sub_offs=
et,
>
>                                sub_len, true, cifs_sb->local_nls);
>
> --
>
> 2.1.4
>
>
> --
>
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
>
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
> --
> Thanks,
>
> Steve
>
>
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve
