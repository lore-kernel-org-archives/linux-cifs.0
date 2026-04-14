Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624AE26F293
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776208217; cv=pass; b=ELoAX397avncUgG4X0tY1wMbuEUwJguLyK8ilQkKDYa+j3MqAEjsTEYvVThNRFWt5J4HOBMt13FskdOHM2wtuQ0qPn+cwx1YGOTyjfvgtDs3hiUXhAjTaw94z9WVx6ad3hi2Jf2SlscdL9u7va31dVMd4cwiif6HBNRNjoyUrZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776208217; c=relaxed/simple;
	bh=NSuJov7NUXjJYXLjtgjFJjn9pZSIrCAMy6LQEOkCqyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mi9jwHkXi5qYYdXmwrVceptRWenZZCfDe3edfRjZQHxJA3Nbj8q/X0BLwBFpPNzy1Ia7xmmgFmOzrWwN0YKXURBXsXqKhAxUaxzXOupWQYkmJJg3S9IbT1XyyBgcCBFhRXPCCeoZSf0lgS+NIfWBBAvX1oAMiP7CBlbW086lu0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Swscrgi2; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Swscrgi2"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8aca6bd57cfso35360166d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 16:10:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776208215; cv=none;
        d=google.com; s=arc-20240605;
        b=kuVVjuL/gD+nb5pIE6NrQgWv6w0UVeOmvBRbcKHXdUlvjolbrK00XNgh+VP14qrOqF
         WMaCi0vvWB6CSegrhQPZu8/LuZcCqDfx1IEMe7IKxWt2LbRy8Hl1nOY2ToqGR0Gvo03G
         st9Dwq4ye48d52CIKnHbaKEGYwX5ksW76Y0NhJXLJWM0PoN34z9sj3atXtX8fIl3eUE7
         lWkSPfqw57fzp0ejt0yd89K2ZzFMB4b2PkM4E/hkUalVT3ZvJ95uLDmXRpIgSgmtEBeo
         YTHeQG9rXdxQizpNyDBbcZr1/PJcrgg4cgHQ8RdSLjtypW/N31xZtoVK7P9tjrTb5eUf
         uqxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3xuXG+G6d5bDfouKBAzWnCaJyjW6aFEUkFbh2VJyogY=;
        fh=13+73Mkl//C6N2QZQI8J2fEyhB9Jr7KAFm40ZFORcis=;
        b=WplJ5/1xvILG7tNDHYCaTs//GRiXjpRRJy31ftZT//EPTNgPBddC/xGM+wZ7MoKsJD
         qP8wjIuGzrf6H4upRdI2luEzGzK9c6Z4zCz+1Z789TFEAajA6/iZwNCyO4r64UvEArFv
         IjakQUfls3gFjcESx+pl6NCDzPEIJJ3cCg5cG4zRp6nwLwpvKrnp2f9avMpldWGQiTWx
         UAAZT1RU9hl/dQZoYSroK1TLxib/T62ShLPdAgKcKnXA457A3YXiROxukKg5TVpatC1m
         WO+t1x3hI4rIZ32sO9M1FYO0OGB8xgTCcJujh4sLxzmkB9Om1x7354PR0sKEyCyD88J4
         vZug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776208215; x=1776813015; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3xuXG+G6d5bDfouKBAzWnCaJyjW6aFEUkFbh2VJyogY=;
        b=Swscrgi2Ms5A5Kb3G/jHYrVDs47aMEUhR8nbW/urOQ0wN6uabxMkEH1+pm+uySLywg
         yTdJiFK3vABaFWzdSxP3SlcsPr1MsOZed6pU2c+susgwqLdZUqjl1VlUgszJsqJnIrE3
         rKWMMzrWRkM1HG04N0jD+FZq2ihHEZ5fCpN0QfbR0KWpYuuq5Hhe3H+FO53rfnG7b3BF
         NwKfxsTKM/MU0/5k/2YwkgAtbseZipYZr7iMAf6ck06hfsJbqCBbYkkOz1zby2aklUkl
         tlxStUMlnQspNUSXlgzNKCwCw6oFI3vD/UdSKqliI5+S26+sSuVXb11LSfF0zGtpuIeR
         Ke2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776208215; x=1776813015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3xuXG+G6d5bDfouKBAzWnCaJyjW6aFEUkFbh2VJyogY=;
        b=KYb8qJBDTCDpiFXL4nUWBEd8XZFosdq1/Z7LsBimPdNnCkGMIjyXKwblG2cX9P8Pfv
         hV0mS2uS4m512/yH2x6xXurfYpSOIRnmqQMhiY2eI8GEpsjrllpP1cpggS61BpYZr4n5
         Yv1/b3VT3yKXFvMlfiXBqKG2espmjuprGwu3k6pWshqfc0fV2QI6glkEqebxSoQs82Ku
         vpWtWr1rQ7BE8n/O9a884gaGnFnUDeCT5YcUc6iKnF7st7EyK4bKYwbBUVE8eE9JchMz
         S4EtOImqp1ESE+goqXjxIdS0aEE31AdihqxozT7X7pIKedPag0C0cymTQ4y/RVh5EzeQ
         qh9Q==
X-Gm-Message-State: AOJu0Yyk2op2hyEo9iUNoZI6czp43lorakzoHfYqSJHfs3fvMqxba8bd
	BiJG1tFZkl/CFua6VdvRLM/dXAZrBkNEEILrC5a3Ew6XHkt9TJUabm26W1mjC9h1MmyVVaLVB5K
	hRqH23HZLpcN+sl/4CM+bcuYdnNDgTxU=
X-Gm-Gg: AeBDievcQOZuWGULxPCd9VLFiIXq3AR1vO/C+z2nbIQduMYwaWInzWTzkFge5GUUqiB
	ePIjdeAQ/ZfUgcMQClLXCvTLbomh38TXa5tLHc8rFpP+0JF/zNX9ZW4cVcPCoQrFWp0w/xWt5Br
	J6opusyVePMlFrHB4CNKOrm0M1VJMQ9cDXkFd8l5ES59nVrD+KEOlXZc6nGC+yDn+s8lyQr2JNE
	ELpNtBj2/KOGiKAetb4Q82K8gZ3mphuQYhevW1c9fTJ+MKC3ssiTutjVfh4pLhHskV2eFnM5Gqq
	GSlNeJ7uAotnuJ6T+jnB2lAkWKbxtG+P6HsIGUjgHPDjtQgESM9OkLziAa08yceRjh3tKICWsaE
	+XQmB037+7IpipurERvrcMrgz32ZGHCfOi2AnmI8DgYRJ86vU9Qn/xWDiL6cJXBRBdjBgsvMiD8
	c1NlhjnnnNVkDQ/P+GTf25hW+u4/0j/Hb1qkN2qb/3fnc=
X-Received: by 2002:a05:6214:5004:b0:8ae:652b:e3ab with SMTP id
 6a1803df08f44-8ae652be942mr44997106d6.51.1776208215355; Tue, 14 Apr 2026
 16:10:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260414161805.233686-1-bharathsm@microsoft.com>
In-Reply-To: <20260414161805.233686-1-bharathsm@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Apr 2026 18:10:04 -0500
X-Gm-Features: AQROBzC9OrUZqeqK95Sgden4aMisVH8NLoTT_QNjgOFlMqVZ1R1U3p_D4YCcELc
Message-ID: <CAH2r5mtMfW9fmaFi2oC33zTmof_o=Wzj1Jxuye1Dd3-wad1siQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] smb: client: add tracepoints for lock operations
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, sprasad@microsoft.com, pc@manguebit.com, 
	ematsumiya@suse.de, henrique.carvalho@suse.com, bharathsm@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Apr 14, 2026 at 11:18=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> Add tracepoints when lock operations are sent to the
> server with details including lock offset, length, and flags.
>
> smb3_lock_enter: before sending lock request
> smb3_lock_done: lock acquired successfully
> smb3_lock_err: lock request failed
> smb3_lock_cached: lock granted from local cache (no server roundtrip)
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/file.c    | 10 +++++--
>  fs/smb/client/smb2pdu.c | 15 ++++++++++-
>  fs/smb/client/trace.h   | 58 ++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 79 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 5d5b49468aff..66a678a0e89f 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -1712,7 +1712,7 @@ cifs_lock_add(struct cifsFileInfo *cfile, struct ci=
fsLockInfo *lock)
>   */
>  static int
>  cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
> -                bool wait)
> +                bool wait, unsigned int xid)
>  {
>         struct cifsLockInfo *conf_lock;
>         struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry));
> @@ -1727,7 +1727,13 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struc=
t cifsLockInfo *lock,
>                                         lock->type, lock->flags, &conf_lo=
ck,
>                                         CIFS_LOCK_OP);
>         if (!exist && cinode->can_cache_brlcks) {
> +               struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
> +
>                 list_add_tail(&lock->llist, &cfile->llist->locks);
> +               trace_smb3_lock_cached(xid, cfile->fid.persistent_fid,
> +                                      tcon->tid, tcon->ses->Suid,
> +                                      lock->offset, lock->length,
> +                                      lock->type, 1, 0);
>                 up_write(&cinode->lock_sem);
>                 return rc;
>         }
> @@ -2342,7 +2348,7 @@ cifs_setlk(struct file *file, struct file_lock *flo=
ck, __u32 type,
>                 if (!lock)
>                         return -ENOMEM;
>
> -               rc =3D cifs_lock_add_if(cfile, lock, wait_flag);
> +               rc =3D cifs_lock_add_if(cfile, lock, wait_flag, xid);
>                 if (rc < 0) {
>                         kfree(lock);
>                         return rc;
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 5188218c25be..61bae531959a 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -6277,6 +6277,11 @@ smb2_lockv(const unsigned int xid, struct cifs_tco=
n *tcon,
>                 smb2_set_replay(server, &rqst);
>         }
>
> +       trace_smb3_lock_enter(xid, persist_fid, tcon->tid, tcon->ses->Sui=
d,
> +                             le64_to_cpu(buf[0].Offset),
> +                             le64_to_cpu(buf[0].Length),
> +                             le32_to_cpu(buf[0].Flags), num_lock, 0);
> +
>         rc =3D cifs_send_recv(xid, tcon->ses, server,
>                             &rqst, &resp_buf_type, flags,
>                             &rsp_iov);
> @@ -6285,7 +6290,15 @@ smb2_lockv(const unsigned int xid, struct cifs_tco=
n *tcon,
>                 cifs_dbg(FYI, "Send error in smb2_lockv =3D %d\n", rc);
>                 cifs_stats_fail_inc(tcon, SMB2_LOCK_HE);
>                 trace_smb3_lock_err(xid, persist_fid, tcon->tid,
> -                                   tcon->ses->Suid, rc);
> +                                   tcon->ses->Suid,
> +                                   le64_to_cpu(buf[0].Offset),
> +                                   le64_to_cpu(buf[0].Length),
> +                                   le32_to_cpu(buf[0].Flags), num_lock, =
rc);
> +       } else {
> +               trace_smb3_lock_done(xid, persist_fid, tcon->tid, tcon->s=
es->Suid,
> +                                    le64_to_cpu(buf[0].Offset),
> +                                    le64_to_cpu(buf[0].Length),
> +                                    le32_to_cpu(buf[0].Flags), num_lock,=
 0);
>         }
>
>         if (is_replayable_error(rc) &&
> diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> index acfbb63086ea..242c9da0283e 100644
> --- a/fs/smb/client/trace.h
> +++ b/fs/smb/client/trace.h
> @@ -670,9 +670,65 @@ DEFINE_EVENT(smb3_fd_err_class, smb3_##name,    \
>         TP_ARGS(xid, fid, tid, sesid, rc))
>
>  DEFINE_SMB3_FD_ERR_EVENT(flush_err);
> -DEFINE_SMB3_FD_ERR_EVENT(lock_err);
>  DEFINE_SMB3_FD_ERR_EVENT(close_err);
>
> +DECLARE_EVENT_CLASS(smb3_lock_class,
> +       TP_PROTO(unsigned int xid,
> +               __u64   fid,
> +               __u32   tid,
> +               __u64   sesid,
> +               __u64   offset,
> +               __u64   len,
> +               __u32   flags,
> +               __u32   num_lock,
> +               int     rc),
> +       TP_ARGS(xid, fid, tid, sesid, offset, len, flags, num_lock, rc),
> +       TP_STRUCT__entry(
> +               __field(unsigned int, xid)
> +               __field(__u64, fid)
> +               __field(__u32, tid)
> +               __field(__u64, sesid)
> +               __field(__u64, offset)
> +               __field(__u64, len)
> +               __field(__u32, flags)
> +               __field(__u32, num_lock)
> +               __field(int, rc)
> +       ),
> +       TP_fast_assign(
> +               __entry->xid =3D xid;
> +               __entry->fid =3D fid;
> +               __entry->tid =3D tid;
> +               __entry->sesid =3D sesid;
> +               __entry->offset =3D offset;
> +               __entry->len =3D len;
> +               __entry->flags =3D flags;
> +               __entry->num_lock =3D num_lock;
> +               __entry->rc =3D rc;
> +       ),
> +       TP_printk("xid=3D%u sid=3D0x%llx tid=3D0x%x fid=3D0x%llx offset=
=3D0x%llx len=3D0x%llx flags=3D0x%x num_lock=3D%u rc=3D%d",
> +               __entry->xid, __entry->sesid, __entry->tid, __entry->fid,
> +               __entry->offset, __entry->len, __entry->flags, __entry->n=
um_lock,
> +               __entry->rc)
> +)
> +
> +#define DEFINE_SMB3_LOCK_EVENT(name)          \
> +DEFINE_EVENT(smb3_lock_class, smb3_##name,    \
> +       TP_PROTO(unsigned int xid,              \
> +               __u64   fid,                    \
> +               __u32   tid,                    \
> +               __u64   sesid,                  \
> +               __u64   offset,                 \
> +               __u64   len,                    \
> +               __u32   flags,                  \
> +               __u32   num_lock,               \
> +               int     rc),                    \
> +       TP_ARGS(xid, fid, tid, sesid, offset, len, flags, num_lock, rc))
> +
> +DEFINE_SMB3_LOCK_EVENT(lock_enter);
> +DEFINE_SMB3_LOCK_EVENT(lock_done);
> +DEFINE_SMB3_LOCK_EVENT(lock_err);
> +DEFINE_SMB3_LOCK_EVENT(lock_cached);
> +
>  /*
>   * For handle based query/set info calls
>   */
> --
> 2.48.1
>


--=20
Thanks,

Steve
