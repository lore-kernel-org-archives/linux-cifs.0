Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AC021A436
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 17:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758387789; cv=none; b=Sj9tjKR81wQmTRyooAW5wU74wethpB43959m1MNorJnBAMMgFgVIH1/4U5dduekXQBtrzhltu7NwGQFeMdwetcWsUHmGMG5bbj/5fMBkxecZbcgIavUVBXt9yGjOv+TJxd6XEHYAaC5x0H7nYwFRTfoPmlN8nffsVzq6CW5NGA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758387789; c=relaxed/simple;
	bh=4qxEUqsvaPqb3NGK72rrjoeojirUewETnJge8P9zvMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NsdCaRP2kksmWhN6zDvhmOpdIKnmLNeiDrkzmnYUScd57FLqiqgbwVmhhvjmLy4mDMB9ypD4LQHqo1v24REbyGCjKIQWEuCOpbuIMPaz9D+JcCbbiJESaBs8mFAGlth3OHoHeK4GE8nHOm4lpOiMPPE/fUFnR5CJrMNnA+S+GQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3rQVm9D; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3rQVm9D"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-78f75b0a058so25282066d6.0
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 10:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758387786; x=1758992586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGV19i+GI/K3GdPTpDdKtA7dg5vNgxS6BugHM97bNRc=;
        b=O3rQVm9D/x3fNBxXdxJNO4g2hP73wgD/P8XoAenar5TxbjjNRtXnkaxVh3Fj22uicZ
         ArAT3Q71opTcchQY9Tbq2XCIaLZ52w2M5qCvFO6dFvcAN3tsagGsohw0cFW0/BpsvQWy
         mzGd9bCXlqGTFAdT0utEPkfvBdPXY9dvhNTDqP5wQBCGlshxnbzxFQhISzj6FZNIZskP
         Q9K5QvSdJbaaYoDNG9VrfqcmhoXDXuhBxV+8UvhySs0P+4u0NpxsFl2zw4li2xErevnd
         9oTM6NgGRUOJAnMAxXpJU3mSztisWk83lNi9Uj8ceuem09tMpBZKdpK1rUt7JM6H3p16
         mrcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758387786; x=1758992586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KGV19i+GI/K3GdPTpDdKtA7dg5vNgxS6BugHM97bNRc=;
        b=OsZf6/nElxadLPUJ9OMPPkpM8pjcvQvT6GenES4wXp1KcEi8X1WR9/2S62oxR+S49O
         CyBF4LjFf7KdJtczwK15AZ9OZg3xdbwOP46Abd2vs6uaDUAbnIfnwXKlgm5evMRgHtR3
         HxKNj2Jai3h4vnWpWwi5RffEPLWJLk1Zp0NRTUzwuzzWFCkmw54RIiQ8KuI/WXeK5L9z
         UB0CIoxhfcMfinb8XSj/bfhCI4I8GgWj0Kr4Avcjqar9owr5d1R4e1XSltXByWzYNZTJ
         gJLD2omFbxDAzzpraskxG9p7dj7zI5YJL1smLk+wj8edXr6fRYSnIiXonVXptBZ4FYkA
         k+dg==
X-Forwarded-Encrypted: i=1; AJvYcCWZzHCZ4x0DuN4/5QYohHXR6P/yzJuQzTJMbFWGsdf1irs41B6aV3x/ig4WwCKKvven1qHiapRa1mDC@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8EFRZswT7i68ygSxejiXgS5gsq3SUT0QqF1tlDKz3NykOArWC
	hb0buq5yaRBWGrK11YStxmfDe7JJzVqMd1xDSNypAVeh+lhtwTyyVGo2qFH1c2N1284RH96uNu/
	OX77g6zAIzxtOFoD6dyxRQWrLFzpN3aU=
X-Gm-Gg: ASbGncvCOzJK3d8oeITPxFa+dwW0mv+egme5bfkVv+y+vOZ0au8vZ9XBh+eSNrrS1jT
	sJekZwV7zkmTBVX1/IgyzYSVMx/DBq0Khg11WT9AIzQLNYYjrsuib4Bx1Z8faEFNXJafi9inEpI
	a4VBjepqQxIxqVmJ1Tq2WB0uACSm2VU6GOaduSEaFAuBptIAgI6n5fdSsSpI0dsbB59yJLTmS14
	D1ZJ0KX7/tMgPxiMiEhCzAHfZPrlV7lVAHnIzQ22ZfA4x2yQ8SaJN1lHDO/JlEl/Odw3GN93PHl
	v8EEPqyJBxwUvtgKRL9LaQo7IwkbWgfLCufsAabVk9VpY6qufSP11Gkbt2oEV0T4Z8w5aIaA6Bp
	t75Ryaog40hbWcEpGPUbe
X-Google-Smtp-Source: AGHT+IEdxSQqJH+B+8ih0EckAOd0ZxKsYEJ7E5eV6zRrQrysYMRe6aZqyjcQKGox2QesZAzDZFDxIAZQTbny8RYQoBk=
X-Received: by 2002:a05:6214:2268:b0:784:d90f:b6d4 with SMTP id
 6a1803df08f44-79912981aabmr76236646d6.15.1758387785842; Sat, 20 Sep 2025
 10:03:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919171315.1137337-1-pc@manguebit.org>
In-Reply-To: <20250919171315.1137337-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 12:02:52 -0500
X-Gm-Features: AS18NWBwG8VuCoRzm_Sm4q1tElnUgR98l5uVQnumTd09a4_ZjwvrNjN1T1wAlKc
Message-ID: <CAH2r5mvEUjSu=tRUSg_fb=FV1PsuZPuViFFpXGNHFFZ2s8GaBQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: handle unlink(2) of files open by different clients
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>, Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

applied to cifs-2.6.git for-next pending additional testing

On Fri, Sep 19, 2025 at 12:13=E2=80=AFPM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> In order to identify whether a certain file is open by a different
> client, start the unlink process by sending a compound request of
> CREATE(DELETE_ON_CLOSE) + CLOSE with only FILE_SHARE_DELETE bit set in
> smb2_create_req::ShareAccess.  If the file is currently open, then the
> server will fail the request with STATUS_SHARING_VIOLATION, in which
> case we'll map it to -EBUSY, so __cifs_unlink() will fall back to
> silly-rename the file.
>
> This fixes the following case where open(O_CREAT) fails with
> -ENOENT (STATUS_DELETE_PENDING) due to file still open by a different
> client.
>
> * Before patch
>
> $ mount.cifs //srv/share /mnt/1 -o ...,nosharesock
> $ mount.cifs //srv/share /mnt/2 -o ...,nosharesock
> $ cd /mnt/1
> $ touch foo
> $ exec 3<>foo
> $ cd /mnt/2
> $ rm foo
> $ touch foo
> touch: cannot touch 'foo': No such file or directory
> $ exec 3>&-
>
> * After patch
>
> $ mount.cifs //srv/share /mnt/1 -o ...,nosharesock
> $ mount.cifs //srv/share /mnt/2 -o ...,nosharesock
> $ cd /mnt/1
> $ touch foo
> $ exec 3<>foo
> $ cd /mnt/2
> $ rm foo
> $ touch foo
> $ exec 3>&-
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Cc: Frank Sorenson <sorenson@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/smb2inode.c | 99 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 88 insertions(+), 11 deletions(-)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 7cadc8ca4f55..e32a3f338793 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1175,23 +1175,92 @@ int
>  smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *=
name,
>             struct cifs_sb_info *cifs_sb, struct dentry *dentry)
>  {
> +       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> +       __le16 *utf16_path __free(kfree) =3D NULL;
> +       int retries =3D 0, cur_sleep =3D 1;
> +       struct TCP_Server_Info *server;
>         struct cifs_open_parms oparms;
> +       struct smb2_create_req *creq;
>         struct inode *inode =3D NULL;
> +       struct smb_rqst rqst[2];
> +       struct kvec rsp_iov[2];
> +       struct kvec close_iov;
> +       int resp_buftype[2];
> +       struct cifs_fid fid;
> +       int flags =3D 0;
> +       __u8 oplock;
>         int rc;
>
> -       if (dentry)
> +       utf16_path =3D cifs_convert_path_to_utf16(name, cifs_sb);
> +       if (!utf16_path)
> +               return -ENOMEM;
> +
> +       if (smb3_encryption_required(tcon))
> +               flags |=3D CIFS_TRANSFORM_REQ;
> +again:
> +       oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> +       server =3D cifs_pick_channel(tcon->ses);
> +
> +       memset(rqst, 0, sizeof(rqst));
> +       memset(resp_buftype, 0, sizeof(resp_buftype));
> +       memset(rsp_iov, 0, sizeof(rsp_iov));
> +
> +       rqst[0].rq_iov =3D open_iov;
> +       rqst[0].rq_nvec =3D ARRAY_SIZE(open_iov);
> +
> +       oparms =3D CIFS_OPARMS(cifs_sb, tcon, name, DELETE | FILE_READ_AT=
TRIBUTES,
> +                            FILE_OPEN, CREATE_DELETE_ON_CLOSE |
> +                            OPEN_REPARSE_POINT, ACL_NO_MODE);
> +       oparms.fid =3D &fid;
> +
> +       if (dentry) {
>                 inode =3D d_inode(dentry);
> +               if (CIFS_I(inode)->lease_granted && server->ops->get_leas=
e_key) {
> +                       oplock =3D SMB2_OPLOCK_LEVEL_LEASE;
> +                       server->ops->get_lease_key(inode, &fid);
> +               }
> +       }
>
> -       oparms =3D CIFS_OPARMS(cifs_sb, tcon, name, DELETE,
> -                            FILE_OPEN, OPEN_REPARSE_POINT, ACL_NO_MODE);
> -       rc =3D smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
> -                             NULL, &(int){SMB2_OP_UNLINK},
> -                             1, NULL, NULL, NULL, dentry);
> -       if (rc =3D=3D -EINVAL) {
> -               cifs_dbg(FYI, "invalid lease key, resending request witho=
ut lease");
> -               rc =3D smb2_compound_op(xid, tcon, cifs_sb, name, &oparms=
,
> -                                     NULL, &(int){SMB2_OP_UNLINK},
> -                                     1, NULL, NULL, NULL, NULL);
> +       rc =3D SMB2_open_init(tcon, server,
> +                           &rqst[0], &oplock, &oparms, utf16_path);
> +       if (rc)
> +               goto err_free;
> +       smb2_set_next_command(tcon, &rqst[0]);
> +       creq =3D rqst[0].rq_iov[0].iov_base;
> +       creq->ShareAccess =3D FILE_SHARE_DELETE_LE;
> +
> +       rqst[1].rq_iov =3D &close_iov;
> +       rqst[1].rq_nvec =3D 1;
> +
> +       rc =3D SMB2_close_init(tcon, server, &rqst[1],
> +                            COMPOUND_FID, COMPOUND_FID, false);
> +       smb2_set_related(&rqst[1]);
> +       if (rc)
> +               goto err_free;
> +
> +       if (retries) {
> +               for (int i =3D 0; i < ARRAY_SIZE(rqst);  i++)
> +                       smb2_set_replay(server, &rqst[i]);
> +       }
> +
> +       rc =3D compound_send_recv(xid, tcon->ses, server, flags,
> +                               ARRAY_SIZE(rqst), rqst,
> +                               resp_buftype, rsp_iov);
> +       SMB2_open_free(&rqst[0]);
> +       SMB2_close_free(&rqst[1]);
> +       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> +       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> +
> +       if (is_replayable_error(rc) &&
> +           smb2_should_replay(tcon, &retries, &cur_sleep))
> +               goto again;
> +
> +       /* Retry compound request without lease */
> +       if (rc =3D=3D -EINVAL && dentry) {
> +               dentry =3D NULL;
> +               retries =3D 0;
> +               cur_sleep =3D 1;
> +               goto again;
>         }
>         /*
>          * If dentry (hence, inode) is NULL, lease break is going to
> @@ -1199,6 +1268,14 @@ smb2_unlink(const unsigned int xid, struct cifs_tc=
on *tcon, const char *name,
>          */
>         if (!rc && inode)
>                 cifs_mark_open_handles_for_deleted_file(inode, name);
> +
> +       return rc;
> +
> +err_free:
> +       SMB2_open_free(&rqst[0]);
> +       SMB2_close_free(&rqst[1]);
> +       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> +       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
>         return rc;
>  }
>
> --
> 2.51.0
>


--=20
Thanks,

Steve
