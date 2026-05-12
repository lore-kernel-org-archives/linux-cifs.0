Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9302A1F5EA
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 03:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778555811; cv=pass; b=Z59WteLFbble83UcohpQ05zdtIuJ9r8F/5xn9E1ynY7/QiKFJvAO8wguUxqeXzRzZD5Zkm4nNzDHK26BfBql1Kkv+TxNZq+9e73YdWFFx8UGG/i28F3R0m4pYUBArotN7N0iJr2RtQdpTOhkHDexofhhFOTnfsbqfyxOdWE+qJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778555811; c=relaxed/simple;
	bh=SCfx820QjFlWcepE2QT9Gkgy/bxzIcCzTtFUpnzEaqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UOvwBGqL0sdEt8EA4txtXY4+dB+Lz+nUnWQKSeu+/TWz09k3QfuJLFkfLjrwmmv2KoKjioFpElRtqMcHAXdKw/ccT/tFdr4wbQjsK/BXU381sVZ21/mImeZu7dfr/sKwsolnFPqzxo2xgXdsDSJd2BxgUVrLxkQohXwub4fCl0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V8412yDt; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V8412yDt"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-90ce49af8easo45148185a.3
        for <linux-cifs@vger.kernel.org>; Mon, 11 May 2026 20:16:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778555805; cv=none;
        d=google.com; s=arc-20240605;
        b=Efa50ACNB1Wo2HdknWEJTNizCtNxQFdUJILvIneWnLJSPMpVRbtR16tVcJrFIzf55A
         S6T2BfniOInmLZC18TBbuVsu9Ux7UsVUsd3Cd+z2+Nofj/zcfMBNOHSz6omG7ZefU6Q4
         QoOgPCT+7EGVlysdqM1876oYoapKoIlznWPB9M8Y4+AJI6ekVj+hpIKbGDl9NFlmYI0N
         WhOgV3dJz0E1SseWCokGVpwgWCNj24E5+UHtDzEqsQY1KwkWwOdU41GJhrzNWI++yVee
         SVUM/oNK/8lw02CsvXJ+S33Ca4qtk4CYuU4tzqxWJwxZvlmfpQAzT+0AtkidcjRiPXj4
         Hn/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k6z1D/YN3TCebCgUwNyNEkXE6ilsWrOU6SDND62NFM8=;
        fh=7A3r6+09tzNnhHTw+uNnYVJyzJRQqAQTAUc0TDW5sqE=;
        b=QbePGXVc11iyjBkjHtp0FUt00Pe9B9Iw0NtWAE6H6xT2nNV2LkSTharnV27RoWpXIt
         mK5BKXgPCLg00GXFzORLThtbXdgrJOfKZsKzjXmDK7Qndnh7uBnnGDEfp6mVR+ipEhXw
         bkk+nq3I9oVg6FkenehbTEBokEZbU7oAQNCqSDn2UVvbb3RRRByGs9dm7A9549oTIBbO
         HD0V7Q98DtN54BZ2aPPwPlA5LeJu+/kLv9e79aE14PgyiVciMo1PMxMIDAvaSZO2iRmL
         YNWjy0XnB5lNVcMd/L3TUrQ9QWyLTzT2q2Sye/9jgkC3dh1yYDCVMqkVbnadNPmV4pxc
         vQ5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778555805; x=1779160605; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k6z1D/YN3TCebCgUwNyNEkXE6ilsWrOU6SDND62NFM8=;
        b=V8412yDte2XDpixVAS1I7WyG0DtdxqlDf7riBP/8/Ggy5B9wu/0P2uQNCGm9PzwxPZ
         gDYb/Re+SGLZz45VO5LL3+3ieQx6Dwuu101sACWvxvlDxKqA10IMtJi4rVgEHyF2KPMG
         W2DaCn0xxGY9wTKsAChSlF6NU7qE6PL18GE3GwvVBjqouZvJgb/3Zhft/XAe3dOut/+n
         m/ZpnEr3V1C5gxgvmTs83yizqWoXF0QiJqau1rRR6u/Qvy/jUYrlBu+/skF0bp9gQ96Y
         X2MioZkUgWp5yA+fmS1uFMuJ8avt//dxdsUKNjZdgN30T/ZN34Ytrp1eVdND2F1xwH3E
         VMOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778555805; x=1779160605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6z1D/YN3TCebCgUwNyNEkXE6ilsWrOU6SDND62NFM8=;
        b=LeB2eiLrloI5Qu2Q2aMymgZnnRwM1nsr2Wjd+3SLN59w8QNP0zJRE3fzSz73h3Mfkm
         fiAYRi7M8ujn3EhXZMqlLzLsND4+gMARXpbFy5EfjE3uSZartKvloO1PyoJU8ntDBi5l
         o62pQ7hTt0CJXy1S3Ja6jZqYXoXe23/4gVycozlUKgKKcMe6Mn+nZwllIse7GtIvrl3S
         IMYUGxyus2EZYnu1zqf/vHiQQWRhONOSa63ymtaAsWk8lRZkqsHN1e6p9QhFX1attpAB
         vcWkdwsPlIh0BGtTVq/8ZQS6cb+dNxBXYFUTViJpfOm3Mw5SH5qRFLFyBgTrACyZig6v
         Abkg==
X-Gm-Message-State: AOJu0Yw/OAS8mwi6FFZOkEFcDZ5z9Jcs6BAJUCdT4P+3xlwyV6smL8bt
	io5vzn6U6VPAS3kSjSa2j8H5yme+8v6B2ctsBzvF69XxUDQaP2zAlqrMG00dybNKirD9AXIIF1Z
	flDs/iVMrC9p2Ozpi6vQjnSIsvj7SSPY=
X-Gm-Gg: Acq92OGWvnIuCbCeAADflJFb6UHENeVdVHfPnLM1x3R1z6Zjg0TPL0UmMQhOSQQQ+U4
	SmC9f6qPkKBULiTYF8asmvvI0TIPqAPzy22htp4nWu+EX5JWiYmgCZy3piY1RlNvNr3WkgGTTxB
	nSZZiP8abM3m7CpfTaUSBX1FzFV8L6WczeteFYGk8jNWULPjDIgyOKeMu51Ylg7Mr3VAMfGFoNc
	1pP152OYV0oqzOo55TCPMVsA1wCaJkWd0JG5TnMpIqVcymtdgX4edGLLI8ovIXK8QDVj+xVhIc5
	cQkUatuvkhcWGs/5JuAVmlw6NplorPoFOY/jHjmcKwmBockrTw/Ch8+DCdtActuLdmJsciykBhE
	wuyJbVO3zG79QAHPp3KsSxSAC1+KYI+qRohwigrVLZHMPuUKAYhqQ4Czm4LAkNzdeph2KDoqvV4
	GmJzoxPw5AZQqVQkoZac8=
X-Received: by 2002:a05:620a:3715:b0:8d7:531:cb8e with SMTP id
 af79cd13be357-907bb7ce32fmr2363198085a.49.1778555805059; Mon, 11 May 2026
 20:16:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501112023.338005-1-sprasad@microsoft.com>
 <20260501112023.338005-6-sprasad@microsoft.com> <CAH2r5muUt5AHP-R6aN5BHS_mZ-Rk=Hw9z0rhANmpHH6Uf1AmXg@mail.gmail.com>
In-Reply-To: <CAH2r5muUt5AHP-R6aN5BHS_mZ-Rk=Hw9z0rhANmpHH6Uf1AmXg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 11 May 2026 22:16:31 -0500
X-Gm-Features: AVHnY4Lz8Ex7Js4s-GME2rPtyRZJ2kCStvCd7n2aQMiCrw_qCr_LTM5jd0YZ_vA
Message-ID: <CAH2r5mtieuhtk1=Onco=5d3uLSBCQoCSGTC0DXV+wcMZ-Gz9vw@mail.gmail.com>
Subject: Re: [PATCH v4 06/19] cifs: optimize readdir for larger directories
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000f96a990651964a16"

--000000000000f96a990651964a16
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated version of patch 4 with fix for build warning attached

On Mon, May 11, 2026 at 10:09=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> This generates build warnings due to
>     if (le16_to_cpu(shdr->Command) =3D=3D SMB2_READ)
> and
>     } else if (le16_to_cpu(shdr->Command) =3D=3D SMB2_QUERY_DIRECTORY)
>
>
>   CC [M]  client/smb2ops.o
>   CHECK   client/smb2ops.c
> client/smb2ops.c:5402:51: warning: restricted __le16 degrades to integer
> client/smb2ops.c:5405:58: warning: restricted __le16 degrades to integer
> client/smb2ops.c:5557:51: warning: restricted __le16 degrades to integer
> client/smb2ops.c:5560:58: warning: restricted __le16 degrades to integer
>
> due to those already being le16, no conversion le16_to_cpu is needed
>
> On Fri, May 1, 2026 at 6:20=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Today QueryDirectory uses the compound_send_recv infrastructure
> > which is limited to 16KB in size. As a result, readdir of large
> > directories generally take several round trips.
> >
> > With this change, if the readdir needs a QueryDir after the first
> > round-trip (meaning that there are more dirents to read), then the
> > following QueryDirs will now switch to using larger buffers with
> > MTU credits.
> >
> > Till now, the only command type that used this flow was SMB2_READ.
> > In case of encrypted response, it becomes challenging to decide if
> > the response is for SMB2_READ or SMB2_READDIR. This change reuses
> > receive_encrypted_read and after decrypting the response decides
> > the handling function based on the command in the resp header. That
> > way, care has been taken to ensure that the read code path
> > modifications on account of this change are kept to a minimum.
> >
> > The change also renames the discard function since both read and
> > query_dir paths will now reuse the same function to discard remaining
> > data in the socket and dequeue the mid.
> >
> > Cc: David Howells <dhowells@redhat.com>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsglob.h  |  21 +-
> >  fs/smb/client/cifsproto.h |   3 +
> >  fs/smb/client/readdir.c   |   2 +-
> >  fs/smb/client/smb1ops.c   |   4 +-
> >  fs/smb/client/smb2misc.c  |   7 +-
> >  fs/smb/client/smb2ops.c   | 458 ++++++++++++++++++++++++++++++++++++--
> >  fs/smb/client/smb2pdu.c   | 185 ++++++++++++++-
> >  fs/smb/client/smb2pdu.h   |   3 +
> >  fs/smb/client/smb2proto.h |   3 +
> >  fs/smb/client/trace.h     |   1 +
> >  fs/smb/client/transport.c | 169 +++++++++++++-
> >  11 files changed, 811 insertions(+), 45 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index 8d089ba08e3e5..38d5600efe2c8 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -504,7 +504,7 @@ struct smb_version_operations {
> >                                struct cifs_search_info *);
> >         /* continue readdir */
> >         int (*query_dir_next)(const unsigned int, struct cifs_tcon *,
> > -                             struct cifs_fid *,
> > +                             struct cifs_sb_info *, struct cifs_fid *,
> >                               __u16, struct cifs_search_info *srch_inf)=
;
> >         /* close dir */
> >         int (*close_dir)(const unsigned int, struct cifs_tcon *,
> > @@ -1397,6 +1397,25 @@ struct cifs_search_info {
> >         bool is_dynamic_buf:1; /* dynamically allocated buffer - can be=
 variable size */
> >  };
> >
> > +/* Structure for QueryDirectory with multi-credit support */
> > +struct cifs_query_dir_io {
> > +       struct cifs_tcon *tcon;
> > +       struct TCP_Server_Info *server;
> > +       struct cifs_search_info *srch_inf;
> > +       unsigned int xid;
> > +       u64 persistent_fid;
> > +       u64 volatile_fid;
> > +       int index;
> > +       struct kvec combined_iov;       /* Pre-allocated buffer to hold=
 resp */
> > +       struct completion done;
> > +       int result;
> > +       struct cifs_credits credits;
> > +       bool replay;
> > +       unsigned int retries;
> > +       unsigned int cur_sleep;
> > +       struct kvec iov[2];             /* For response handling */
> > +};
> > +
> >  #define ACL_NO_MODE    ((umode_t)(-1))
> >  struct cifs_open_parms {
> >         struct cifs_tcon *tcon;
> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > index 884bfa1cf0b42..bbbee0ef09443 100644
> > --- a/fs/smb/client/cifsproto.h
> > +++ b/fs/smb/client/cifsproto.h
> > @@ -336,6 +336,9 @@ struct cifs_ses *cifs_get_smb_ses(struct TCP_Server=
_Info *server,
> >  int cifs_readv_receive(struct TCP_Server_Info *server,
> >                        struct mid_q_entry *mid);
> >
> > +int cifs_query_dir_receive(struct TCP_Server_Info *server,
> > +                           struct mid_q_entry *mid);
> > +
> >  int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> >                           struct cifs_sb_info *cifs_sb,
> >                           const unsigned char *path, char *pbuf,
> > diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> > index b50efd9b9e1d2..8a444f97e0ae9 100644
> > --- a/fs/smb/client/readdir.c
> > +++ b/fs/smb/client/readdir.c
> > @@ -760,7 +760,7 @@ find_cifs_entry(const unsigned int xid, struct cifs=
_tcon *tcon, loff_t pos,
> >         while ((index_to_find >=3D cfile->srch_inf.index_of_last_entry)=
 &&
> >                (rc =3D=3D 0) && !cfile->srch_inf.endOfSearch) {
> >                 cifs_dbg(FYI, "calling findnext2\n");
> > -               rc =3D server->ops->query_dir_next(xid, tcon, &cfile->f=
id,
> > +               rc =3D server->ops->query_dir_next(xid, tcon, cifs_sb, =
&cfile->fid,
> >                                                  search_flags,
> >                                                  &cfile->srch_inf);
> >                 if (rc)
> > diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> > index 9694117050a6c..860a9b23a2f8d 100644
> > --- a/fs/smb/client/smb1ops.c
> > +++ b/fs/smb/client/smb1ops.c
> > @@ -1135,8 +1135,8 @@ cifs_query_dir_first(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> >
> >  static int
> >  cifs_query_dir_next(const unsigned int xid, struct cifs_tcon *tcon,
> > -                   struct cifs_fid *fid, __u16 search_flags,
> > -                   struct cifs_search_info *srch_inf)
> > +                   struct cifs_sb_info *cifs_sb, struct cifs_fid *fid,
> > +                   __u16 search_flags, struct cifs_search_info *srch_i=
nf)
> >  {
> >         return CIFSFindNext(xid, tcon, fid->netfid, search_flags, srch_=
inf);
> >  }
> > diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> > index 973fce3c959c4..b7b6ecd5fdaee 100644
> > --- a/fs/smb/client/smb2misc.c
> > +++ b/fs/smb/client/smb2misc.c
> > @@ -12,6 +12,7 @@
> >  #include "cifsglob.h"
> >  #include "cifsproto.h"
> >  #include "smb2proto.h"
> > +#include "smb2pdu.h"
> >  #include "cifs_debug.h"
> >  #include "cifs_unicode.h"
> >  #include "../common/smb2status.h"
> > @@ -316,7 +317,7 @@ char *
> >  smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
> >  {
> >         const int max_off =3D 4096;
> > -       const int max_len =3D 128 * 1024;
> > +       int max_len =3D 128 * 1024;
> >
> >         *off =3D 0;
> >         *len =3D 0;
> > @@ -367,6 +368,10 @@ smb2_get_data_area_len(int *off, int *len, struct =
smb2_hdr *shdr)
> >                   ((struct smb2_query_directory_rsp *)shdr)->OutputBuff=
erOffset);
> >                 *len =3D le32_to_cpu(
> >                   ((struct smb2_query_directory_rsp *)shdr)->OutputBuff=
erLength);
> > +               /* Allow larger buffers for query directory (up to 2MB)=
.
> > +                * The actual data is handled separately in cifs_query_=
dir_receive().
> > +                */
> > +               max_len =3D SMB2_MAX_QD_DATABUF_SIZE;
> >                 break;
> >         case SMB2_IOCTL:
> >                 *off =3D le32_to_cpu(
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index f075330f88598..2df4d080e95f0 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -2713,11 +2713,131 @@ smb2_query_dir_first(const unsigned int xid, s=
truct cifs_tcon *tcon,
> >
> >  static int
> >  smb2_query_dir_next(const unsigned int xid, struct cifs_tcon *tcon,
> > -                   struct cifs_fid *fid, __u16 search_flags,
> > -                   struct cifs_search_info *srch_inf)
> > +                   struct cifs_sb_info *cifs_sb, struct cifs_fid *fid,
> > +                   __u16 search_flags, struct cifs_search_info *srch_i=
nf)
> >  {
> > -       return SMB2_query_directory(xid, tcon, fid->persistent_fid,
> > -                                   fid->volatile_fid, 0, srch_inf);
> > +       struct cifs_query_dir_io qd_io;
> > +       struct TCP_Server_Info *server;
> > +       struct cifs_ses *ses =3D tcon->ses;
> > +       size_t buf_size;
> > +       int rc;
> > +       int resp_buftype =3D CIFS_DYNAMIC_BUFFER;
> > +
> > +       /* Pick server and determine buffer size based on negotiated rs=
ize */
> > +       server =3D cifs_pick_channel(ses);
> > +       if (!server)
> > +               return smb_EIO(smb_eio_trace_null_pointers);
> > +
> > +       /* Negotiate rsize if not already set */
> > +       if (cifs_sb->ctx->rsize =3D=3D 0)
> > +               cifs_negotiate_rsize(server, cifs_sb->ctx, tcon);
> > +
> > +       /* Use negotiated rsize for buffer size, with reasonable limits=
 */
> > +       buf_size =3D cifs_sb->ctx->rsize;
> > +
> > +       cifs_dbg(FYI, "%s: using buffer size %zu (rsize=3D%u, encrypted=
=3D%d)\n",
> > +                __func__, buf_size, cifs_sb->ctx->rsize, smb3_encrypti=
on_required(tcon));
> > +
> > +       /* Initialize qd_io structure */
> > +       memset(&qd_io, 0, sizeof(qd_io));
> > +       qd_io.tcon =3D tcon;
> > +       qd_io.server =3D server;
> > +       qd_io.srch_inf =3D srch_inf;
> > +       qd_io.xid =3D xid;
> > +       qd_io.persistent_fid =3D fid->persistent_fid;
> > +       qd_io.volatile_fid =3D fid->volatile_fid;
> > +       qd_io.index =3D 0;
> > +       qd_io.result =3D 0;
> > +       qd_io.replay =3D false;
> > +       qd_io.retries =3D 0;
> > +       qd_io.cur_sleep =3D 0;
> > +
> > +       /* Allocate credits for the buffer size */
> > +       rc =3D server->ops->wait_mtu_credits(server, buf_size, &buf_siz=
e,
> > +                                          &qd_io.credits);
> > +       if (rc) {
> > +               cifs_dbg(VFS, "%s: failed to get credits: %d\n", __func=
__, rc);
> > +               return rc;
> > +       }
> > +
> > +       cifs_dbg(FYI, "%s: allocated %u credits for %zu bytes\n",
> > +                __func__, qd_io.credits.value, buf_size);
> > +
> > +       /* Send query directory with large buffer and wait for completi=
on */
> > +       rc =3D SMB2_query_directory_large(&qd_io, buf_size);
> > +       if (rc) {
> > +               if (rc =3D=3D -ENODATA) {
> > +                       const struct smb2_hdr *hdr =3D NULL;
> > +
> > +                       if (qd_io.combined_iov.iov_base)
> > +                               hdr =3D (const struct smb2_hdr *)qd_io.=
combined_iov.iov_base;
> > +                       else if (qd_io.iov[0].iov_base)
> > +                               hdr =3D (const struct smb2_hdr *)qd_io.=
iov[0].iov_base;
> > +
> > +                       /*
> > +                        * ENODATA from QUERY_DIRECTORY generally means=
 enumeration reached
> > +                        * the end. Treat it as end-of-search even if t=
he header buffer is
> > +                        * unavailable in this async path.
> > +                        */
> > +                       if (!hdr) {
> > +                               cifs_dbg(FYI, "%s: ENODATA but hdr is N=
ULL\n", __func__);
> > +                       } else {
> > +                               cifs_dbg(FYI, "%s: ENODATA with hdr->St=
atus=3D0x%x (STATUS_NO_MORE_FILES=3D0x%x)\n",
> > +                                        __func__, le32_to_cpu(hdr->Sta=
tus), le32_to_cpu(STATUS_NO_MORE_FILES));
> > +                       }
> > +
> > +                       if (hdr && hdr->Status =3D=3D STATUS_NO_MORE_FI=
LES) {
> > +                               trace_smb3_query_dir_done(xid, fid->per=
sistent_fid,
> > +                                       tcon->tid, tcon->ses->Suid, 0, =
0);
> > +                               srch_inf->endOfSearch =3D true;
> > +                               rc =3D 0;
> > +                       } else {
> > +                               cifs_dbg(FYI, "%s: ENODATA but Status m=
ismatch - not treating as end-of-search\n",
> > +                                       __func__);
> > +                               trace_smb3_query_dir_err(xid, fid->pers=
istent_fid,
> > +                                       tcon->tid, tcon->ses->Suid, 0, =
0, rc);
> > +                       }
> > +               } else {
> > +                       trace_smb3_query_dir_err(xid, fid->persistent_f=
id,
> > +                               tcon->tid, tcon->ses->Suid, 0, 0, rc);
> > +               }
> > +               goto qdir_next_exit;
> > +       }
> > +
> > +       /* Parse the response using the combined buffer built in receiv=
e handler */
> > +       if (qd_io.combined_iov.iov_len > 0) {
> > +               rc =3D smb2_parse_query_directory(tcon, &qd_io.combined=
_iov, resp_buftype,
> > +                                               srch_inf);
> > +               if (rc) {
> > +                       trace_smb3_query_dir_err(xid, fid->persistent_f=
id,
> > +                               tcon->tid, tcon->ses->Suid, 0, 0, rc);
> > +                       kfree(qd_io.combined_iov.iov_base);
> > +                       qd_io.combined_iov.iov_base =3D NULL;
> > +                       goto qdir_next_exit;
> > +               }
> > +
> > +               /* combined_iov.iov_base ownership transferred to srch_=
inf->ntwrk_buf_start */
> > +               qd_io.combined_iov.iov_base =3D NULL;
> > +
> > +               trace_smb3_query_dir_done(xid, fid->persistent_fid,
> > +                       tcon->tid, tcon->ses->Suid, 0,
> > +                       srch_inf->entries_in_buffer);
> > +       }
> > +
> > +qdir_next_exit:
> > +       /* Free the data buffer if not transferred to srch_inf */
> > +       kfree(qd_io.combined_iov.iov_base);
> > +
> > +       /* Return credits if we still have them (they should have been =
cleared in callback) */
> > +       if (qd_io.credits.value !=3D 0) {
> > +               trace_smb3_rw_credits(0, 0, 0,
> > +                                     server->credits, server->in_fligh=
t,
> > +                                     qd_io.credits.value,
> > +                                     cifs_trace_rw_credits_query_dir_d=
one);
> > +               add_credits(server, &qd_io.credits, 0);
> > +       }
> > +
> > +       return rc;
> >  }
> >
> >  static int
> > @@ -4834,6 +4954,252 @@ cifs_copy_folioq_to_iter(struct folio_queue *fo=
lioq, size_t data_size,
> >         return 0;
> >  }
> >
> > +static int
> > +cifs_copy_folioq_to_buf(struct folio_queue *folioq, size_t total_size,
> > +                       size_t skip, char *buf, size_t buf_len)
> > +{
> > +       size_t copied =3D 0;
> > +
> > +       if (buf_len > total_size - skip)
> > +               buf_len =3D total_size - skip;
> > +
> > +       for (; folioq; folioq =3D folioq->next) {
> > +               for (int s =3D 0; s < folioq_count(folioq); s++) {
> > +                       struct folio *folio =3D folioq_folio(folioq, s)=
;
> > +                       size_t fsize =3D folio_size(folio);
> > +                       size_t len =3D umin(fsize - skip, buf_len);
> > +
> > +                       if (len =3D=3D 0)
> > +                               break;
> > +
> > +                       memcpy_from_folio(buf + copied, folio, skip, le=
n);
> > +                       copied +=3D len;
> > +                       buf_len -=3D len;
> > +                       skip =3D 0;
> > +
> > +                       if (buf_len =3D=3D 0)
> > +                               return 0;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +/*
> > + * Handle encrypted QueryDirectory response data.
> > + * Called only for encrypted responses where mid->decrypted =3D=3D tru=
e.
> > + * For unencrypted responses, cifs_query_dir_receive handles everythin=
g.
> > + *
> > + * This is written in such a way that handle_read_data does not need m=
odification.
> > + *
> > + * buf: contains read_rsp_size bytes of decrypted response
> > + * buffer: contains (total_len - read_rsp_size) bytes of decrypted dat=
a
> > + *
> > + * Since sizeof(struct smb2_query_directory_rsp) < read_rsp_size,
> > + * the response header is always fully in buf. Data may be split betwe=
en
> > + * buf and buffer depending on data_offset.
> > + */
> > +static int
> > +handle_query_dir_data(struct TCP_Server_Info *server, struct mid_q_ent=
ry *mid,
> > +                     char *buf, unsigned int buf_len, struct folio_que=
ue *buffer,
> > +                     unsigned int buffer_len, bool is_offloaded)
> > +{
> > +       struct cifs_query_dir_io *qd_io =3D mid->callback_data;
> > +       struct smb2_query_directory_rsp *rsp;
> > +       struct smb2_hdr *shdr =3D (struct smb2_hdr *)buf;
> > +       unsigned int data_offset, data_len;
> > +       unsigned int hdr_len;
> > +
> > +       cifs_dbg(FYI, "%s: processing encrypted QueryDirectory response=
\n", __func__);
> > +
> > +       if (shdr->Command !=3D SMB2_QUERY_DIRECTORY) {
> > +               cifs_server_dbg(VFS, "only QueryDirectory responses are=
 supported\n");
> > +               return -EOPNOTSUPP;
> > +       }
> > +
> > +       if (server->ops->is_session_expired &&
> > +           server->ops->is_session_expired(buf)) {
> > +               if (!is_offloaded)
> > +                       cifs_reconnect(server, true);
> > +               return -1;
> > +       }
> > +
> > +       if (server->ops->is_status_pending &&
> > +                       server->ops->is_status_pending(buf, server))
> > +               return -1;
> > +
> > +       rsp =3D (struct smb2_query_directory_rsp *)buf;
> > +       hdr_len =3D min_t(unsigned int, buf_len,
> > +                        sizeof(struct smb2_query_directory_rsp));
> > +
> > +       /* Map error code first */
> > +       qd_io->result =3D server->ops->map_error(buf, false);
> > +
> > +       /* Get data_offset early to set up iov properly */
> > +       data_offset =3D le16_to_cpu(rsp->OutputBufferOffset);
> > +       data_len =3D le32_to_cpu(rsp->OutputBufferLength);
> > +
> > +       /* Set up first iov to point to header portion (needed for cred=
its/signature) */
> > +       qd_io->iov[0].iov_base =3D buf;
> > +       qd_io->iov[0].iov_len =3D qd_io->result ? hdr_len : data_offset=
;
> > +
> > +       if (qd_io->result !=3D 0) {
> > +               cifs_dbg(FYI, "%s: server returned error %d (Status=3D0=
x%x)\n",
> > +                        __func__, qd_io->result, le32_to_cpu(rsp->hdr.=
Status));
> > +
> > +               /*
> > +                * Copy header to persistent combined_iov buffer so sta=
tus
> > +                * remains accessible after receive handler returns. bu=
f is temporary
> > +                * and will be freed/reused, so we can't leave iov[0] p=
ointing to it
> > +                */
> > +               if (qd_io->combined_iov.iov_base && hdr_len > 0 &&
> > +                   hdr_len <=3D qd_io->combined_iov.iov_len) {
> > +                       memcpy(qd_io->combined_iov.iov_base, buf, hdr_l=
en);
> > +                       qd_io->iov[0].iov_base =3D qd_io->combined_iov.=
iov_base;
> > +                       qd_io->iov[0].iov_len =3D hdr_len;
> > +                       cifs_dbg(FYI, "%s: copied error response header=
 to combined_iov\n",
> > +                               __func__);
> > +               }
> > +
> > +               /*
> > +                * Normal error on query_directory response - response =
received successfully,
> > +                * but the command failed. Store error in qd_io->result=
 for callback
> > +                */
> > +               if (is_offloaded)
> > +                       mid->mid_state =3D MID_RESPONSE_RECEIVED;
> > +               else
> > +                       dequeue_mid(server, mid, false);
> > +               return 0;
> > +       }
> > +
> > +       /* Success - parse the response data */
> > +       cifs_dbg(FYI, "%s: data_offset=3D%u data_len=3D%u buf_len=3D%u =
buffer_len=3D%u\n",
> > +                __func__, data_offset, data_len, buf_len, buffer_len);
> > +
> > +       /* Validate data_offset */
> > +       if (data_offset < sizeof(struct smb2_query_directory_rsp)) {
> > +               cifs_dbg(FYI, "%s: data offset (%u) inside response hea=
der\n",
> > +                        __func__, data_offset);
> > +               data_offset =3D sizeof(struct smb2_query_directory_rsp)=
;
> > +       } else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
> > +               cifs_dbg(VFS, "%s: data offset (%u) beyond end of small=
buf\n",
> > +                        __func__, data_offset);
> > +               qd_io->result =3D -EIO;
> > +               dequeue_mid(server, mid, qd_io->result);
> > +               return qd_io->result;
> > +       }
> > +
> > +       /* Validate data_offset is within buf_len + buffer_len */
> > +       if (data_offset > buf_len + buffer_len) {
> > +               cifs_dbg(VFS, "%s: data offset (%u) beyond response len=
gth (%u)\n",
> > +                        __func__, data_offset, buf_len + buffer_len);
> > +               qd_io->result =3D -EIO;
> > +               dequeue_mid(server, mid, qd_io->result);
> > +               return qd_io->result;
> > +       }
> > +
> > +       /* Validate response fits in pre-allocated combined buffer */
> > +       if ((size_t)data_offset + data_len > qd_io->combined_iov.iov_le=
n) {
> > +               cifs_dbg(VFS, "%s: response (%u + %u) exceeds buffer ca=
pacity (%zu)\n",
> > +                        __func__, data_offset, data_len, qd_io->combin=
ed_iov.iov_len);
> > +               qd_io->result =3D -EIO;
> > +               dequeue_mid(server, mid, qd_io->result);
> > +               return qd_io->result;
> > +       }
> > +
> > +       /* Copy the prefix present in buf into combined_iov, preserving=
 wire layout */
> > +       memcpy(qd_io->combined_iov.iov_base, buf, min(data_offset, buf_=
len));
> > +
> > +       if (data_offset < buf_len) {
> > +               /* Data starts in buf, may continue into buffer */
> > +               unsigned int data_in_buf =3D buf_len - data_offset;
> > +               unsigned int data_in_buffer;
> > +
> > +               if (data_len <=3D data_in_buf) {
> > +                       /* All data is in buf */
> > +                       memcpy(qd_io->combined_iov.iov_base + data_offs=
et,
> > +                              buf + data_offset, data_len);
> > +               } else {
> > +                       /* Copy from buf first */
> > +                       memcpy(qd_io->combined_iov.iov_base + data_offs=
et,
> > +                              buf + data_offset, data_in_buf);
> > +
> > +                       /* Copy remainder from buffer at offset 0 */
> > +                       data_in_buffer =3D data_len - data_in_buf;
> > +                       if (data_in_buffer > buffer_len) {
> > +                               cifs_dbg(VFS, "%s: data_in_buffer (%u) =
> buffer_len (%u)\n",
> > +                                        __func__, data_in_buffer, buff=
er_len);
> > +                               qd_io->result =3D -EIO;
> > +                               dequeue_mid(server, mid, qd_io->result)=
;
> > +                               return qd_io->result;
> > +                       }
> > +
> > +                       qd_io->result =3D cifs_copy_folioq_to_buf(buffe=
r, buffer_len, 0,
> > +                                                               qd_io->=
combined_iov.iov_base +
> > +                                                               data_of=
fset + data_in_buf,
> > +                                                               data_in=
_buffer);
> > +                       if (qd_io->result !=3D 0) {
> > +                               cifs_dbg(VFS, "%s: failed to copy from =
folio_queue: %d\n",
> > +                                        __func__, qd_io->result);
> > +                               dequeue_mid(server, mid, qd_io->result)=
;
> > +                               return qd_io->result;
> > +                       }
> > +               }
> > +       } else {
> > +               /* Padding and data are in buffer starting at offset 0 =
*/
> > +               unsigned int bytes_in_buffer =3D data_offset - buf_len =
+ data_len;
> > +
> > +               if (bytes_in_buffer > buffer_len) {
> > +                       cifs_dbg(VFS, "%s: data beyond buffer: prefix+l=
en=3D%u buffer_len=3D%u\n",
> > +                                __func__, bytes_in_buffer, buffer_len)=
;
> > +                       qd_io->result =3D -EIO;
> > +                       dequeue_mid(server, mid, qd_io->result);
> > +                       return qd_io->result;
> > +               }
> > +
> > +               qd_io->result =3D cifs_copy_folioq_to_buf(buffer, buffe=
r_len, 0,
> > +                                                       qd_io->combined=
_iov.iov_base + buf_len,
> > +                                                       bytes_in_buffer=
);
> > +               if (qd_io->result !=3D 0) {
> > +                       cifs_dbg(VFS, "%s: failed to copy from folio_qu=
eue: %d\n",
> > +                                __func__, qd_io->result);
> > +                       dequeue_mid(server, mid, qd_io->result);
> > +                       return qd_io->result;
> > +               }
> > +       }
> > +
> > +       /* Set up iov[1] pointing into combined buffer, finalize valid =
length */
> > +       qd_io->iov[1].iov_base =3D qd_io->combined_iov.iov_base + data_=
offset;
> > +       qd_io->iov[1].iov_len =3D data_len;
> > +       qd_io->combined_iov.iov_len =3D data_offset + data_len;
> > +
> > +       dequeue_mid(server, mid, false);
> > +       return 0;
> > +}
> > +
> > +/*
> > + * Handle callback for async QueryDirectory with multi-credit support.
> > + * For encrypted responses, extracts decrypted data.
> > + * For unencrypted responses, cifs_query_dir_receive already processed=
 everything.
> > + */
> > +int
> > +smb2_query_dir_handle_data(struct TCP_Server_Info *server, struct mid_=
q_entry *mid)
> > +{
> > +       char *buf =3D server->large_buf ? server->bigbuf : server->smal=
lbuf;
> > +
> > +       /* For unencrypted responses, data already processed in cifs_qu=
ery_dir_receive */
> > +       if (!mid->decrypted)
> > +               return 0;
> > +
> > +       /*
> > +        * For small encrypted responses (< CIFSMaxBufSize), all data i=
s in buf.
> > +        * For large encrypted responses, this callback is not used - i=
nstead,
> > +        * receive_encrypted_read/smb2_decrypt_offload call handle_quer=
y_dir_data directly.
> > +        */
> > +       return handle_query_dir_data(server, mid, buf, server->pdu_size=
,
> > +                                     NULL, 0, false);
> > +}
> > +
> >  static int
> >  handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *m=
id,
> >                  char *buf, unsigned int buf_len, struct folio_queue *b=
uffer,
> > @@ -4997,25 +5363,46 @@ static void smb2_decrypt_offload(struct work_st=
ruct *work)
> >         int rc;
> >         struct mid_q_entry *mid;
> >         struct iov_iter iter;
> > +       struct smb2_hdr *shdr;
> > +       unsigned int read_rsp_size =3D dw->server->vals->read_rsp_size;
> >
> > +       /* decrypt read_rsp_size in buf + remainder in folio_queue */
> >         iov_iter_folio_queue(&iter, ITER_DEST, dw->buffer, 0, 0, dw->le=
n);
> > -       rc =3D decrypt_raw_data(dw->server, dw->buf, dw->server->vals->=
read_rsp_size,
> > -                             &iter, true);
> > +       rc =3D decrypt_raw_data(dw->server, dw->buf, read_rsp_size, &it=
er, true);
> >         if (rc) {
> >                 cifs_dbg(VFS, "error decrypting rc=3D%d\n", rc);
> >                 goto free_pages;
> >         }
> >
> >         dw->server->lstrp =3D jiffies;
> > +
> > +       shdr =3D (struct smb2_hdr *)(dw->buf + sizeof(struct smb2_trans=
form_hdr));
> > +
> > +       /*
> > +        * buf now contains read_rsp_size bytes after transform_hdr.
> > +        * folio_queue contains (total_len - read_rsp_size) bytes.
> > +        * The handle functions will determine where data actually star=
ts based on data_offset.
> > +        */
> > +
> >         mid =3D smb2_find_dequeue_mid(dw->server, dw->buf);
> >         if (mid =3D=3D NULL)
> >                 cifs_dbg(FYI, "mid not found\n");
> >         else {
> >                 mid->decrypted =3D true;
> > -               rc =3D handle_read_data(dw->server, mid, dw->buf,
> > -                                     dw->server->vals->read_rsp_size,
> > -                                     dw->buffer, dw->len,
> > -                                     true);
> > +
> > +               /* Handle based on command type */
> > +               if (le16_to_cpu(shdr->Command) =3D=3D SMB2_READ) {
> > +                       rc =3D handle_read_data(dw->server, mid, dw->bu=
f, read_rsp_size,
> > +                                             dw->buffer, dw->len, true=
);
> > +               } else if (le16_to_cpu(shdr->Command) =3D=3D SMB2_QUERY=
_DIRECTORY) {
> > +                       rc =3D handle_query_dir_data(dw->server, mid, d=
w->buf, read_rsp_size,
> > +                                                  dw->buffer, dw->len,=
 true);
> > +               } else {
> > +                       cifs_dbg(VFS, "Unexpected command %u in decrypt=
 offload\n",
> > +                                le16_to_cpu(shdr->Command));
> > +                       rc =3D -EOPNOTSUPP;
> > +               }
> > +
> >                 if (rc >=3D 0) {
> >  #ifdef CONFIG_CIFS_STATS2
> >                         mid->when_received =3D jiffies;
> > @@ -5059,9 +5446,10 @@ receive_encrypted_read(struct TCP_Server_Info *s=
erver, struct mid_q_entry **mid,
> >  {
> >         char *buf =3D server->smallbuf;
> >         struct smb2_transform_hdr *tr_hdr =3D (struct smb2_transform_hd=
r *)buf;
> > +       struct smb2_hdr *shdr;
> >         struct iov_iter iter;
> > -       unsigned int len;
> > -       unsigned int buflen =3D server->pdu_size;
> > +       unsigned int len, total_len, buflen =3D server->pdu_size;
> > +       unsigned int read_rsp_size =3D server->vals->read_rsp_size;
> >         int rc;
> >         struct smb2_decrypt_work *dw;
> >
> > @@ -5072,7 +5460,10 @@ receive_encrypted_read(struct TCP_Server_Info *s=
erver, struct mid_q_entry **mid,
> >         dw->server =3D server;
> >
> >         *num_mids =3D 1;
> > -       len =3D min_t(unsigned int, buflen, server->vals->read_rsp_size=
 +
> > +       total_len =3D le32_to_cpu(tr_hdr->OriginalMessageSize);
> > +
> > +       /* Read transform_hdr + read_rsp_size into buf */
> > +       len =3D min_t(unsigned int, buflen, read_rsp_size +
> >                 sizeof(struct smb2_transform_hdr)) - HEADER_SIZE(server=
) + 1;
> >
> >         rc =3D cifs_read_from_socket(server, buf + HEADER_SIZE(server) =
- 1, len);
> > @@ -5080,9 +5471,8 @@ receive_encrypted_read(struct TCP_Server_Info *se=
rver, struct mid_q_entry **mid,
> >                 goto free_dw;
> >         server->total_read +=3D rc;
> >
> > -       len =3D le32_to_cpu(tr_hdr->OriginalMessageSize) -
> > -               server->vals->read_rsp_size;
> > -       dw->len =3D len;
> > +       /* Read remaining data into folio_queue */
> > +       dw->len =3D total_len - read_rsp_size;
> >         len =3D round_up(dw->len, PAGE_SIZE);
> >
> >         size_t cur_size =3D 0;
> > @@ -5111,7 +5501,7 @@ receive_encrypted_read(struct TCP_Server_Info *se=
rver, struct mid_q_entry **mid,
> >                 goto free_pages;
> >
> >         /*
> > -        * For large reads, offload to different thread for better perf=
ormance,
> > +        * For large responses, offload to different thread for better =
performance,
> >          * use more cores decrypting which can be expensive
> >          */
> >
> > @@ -5125,20 +5515,41 @@ receive_encrypted_read(struct TCP_Server_Info *=
server, struct mid_q_entry **mid,
> >                 return -1;
> >         }
> >
> > -       rc =3D decrypt_raw_data(server, buf, server->vals->read_rsp_siz=
e,
> > -                             &iter, false);
> > +       /* Decrypt: read_rsp_size in buf + remainder in folio_queue */
> > +       rc =3D decrypt_raw_data(server, buf, read_rsp_size, &iter, fals=
e);
> >         if (rc)
> >                 goto free_pages;
> >
> > +       shdr =3D (struct smb2_hdr *) buf;
> > +
> > +       /*
> > +        * buf now contains the complete response header (read_rsp_size=
 bytes).
> > +        * folio_queue contains (total_len - read_rsp_size) bytes.
> > +        * The handle functions will determine where data actually star=
ts based on data_offset.
> > +        */
> > +
> >         *mid =3D smb2_find_mid(server, buf);
> >         if (*mid =3D=3D NULL) {
> >                 cifs_dbg(FYI, "mid not found\n");
> >         } else {
> > -               cifs_dbg(FYI, "mid found\n");
> > +               cifs_dbg(FYI, "mid found, command=3D%u\n", le16_to_cpu(=
shdr->Command));
> >                 (*mid)->decrypted =3D true;
> > -               rc =3D handle_read_data(server, *mid, buf,
> > -                                     server->vals->read_rsp_size,
> > -                                     dw->buffer, dw->len, false);
> > +
> > +               /* Handle based on command type */
> > +               if (le16_to_cpu(shdr->Command) =3D=3D SMB2_READ) {
> > +                       rc =3D handle_read_data(server, *mid, buf, read=
_rsp_size,
> > +                                             dw->buffer, dw->len, fals=
e);
> > +               } else if (le16_to_cpu(shdr->Command) =3D=3D SMB2_QUERY=
_DIRECTORY) {
> > +                       rc =3D handle_query_dir_data(server, *mid, buf,=
 read_rsp_size,
> > +                                                  dw->buffer, dw->len,=
 false);
> > +               } else {
> > +                       /* For now, other commands not supported in lar=
ge encrypted path */
> > +                       cifs_server_dbg(VFS,
> > +                                       "Large encrypted responses only=
 supported for SMB2_READ and SMB2_QUERY_DIRECTORY (got %u)\n",
> > +                                       le16_to_cpu(shdr->Command));
> > +                       rc =3D -EOPNOTSUPP;
> > +               }
> > +
> >                 if (rc >=3D 0) {
> >                         if (server->ops->is_network_name_deleted) {
> >                                 server->ops->is_network_name_deleted(bu=
f,
> > @@ -5279,7 +5690,6 @@ smb3_receive_transform(struct TCP_Server_Info *se=
rver,
> >                 return -ECONNABORTED;
> >         }
> >
> > -       /* TODO: add support for compounds containing READ. */
> >         if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server)) {
> >                 return receive_encrypted_read(server, &mids[0], num_mid=
s);
> >         }
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index 2d55246d2851b..92724cfb5b3f5 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -5496,6 +5496,185 @@ num_entries(int infotype, char *bufstart, char =
*end_of_buf, char **lastentry,
> >         return entrycount;
> >  }
> >
> > +/*
> > + * Callback for async QueryDirectory with multi-credit support
> > + */
> > +static void
> > +smb2_query_dir_callback(struct TCP_Server_Info *server, struct mid_q_e=
ntry *mid)
> > +{
> > +       struct cifs_query_dir_io *qd_io =3D mid->callback_data;
> > +       struct cifs_tcon *tcon =3D qd_io->tcon;
> > +       struct smb2_hdr *shdr =3D (struct smb2_hdr *)qd_io->iov[0].iov_=
base;
> > +       struct cifs_credits credits =3D {
> > +               .value =3D 0,
> > +               .instance =3D 0,
> > +       };
> > +
> > +       WARN_ONCE(qd_io->server !=3D server,
> > +                 "qd_io server %p !=3D mid server %p",
> > +                 qd_io->server, server);
> > +
> > +       cifs_dbg(FYI, "%s: mid=3D%llu state=3D%d result=3D%d\n",
> > +                __func__, mid->mid, mid->mid_state, qd_io->result);
> > +
> > +       switch (mid->mid_state) {
> > +       case MID_RESPONSE_RECEIVED:
> > +               credits.value =3D le16_to_cpu(shdr->CreditRequest);
> > +               credits.instance =3D server->reconnect_instance;
> > +               /* result already set, check signature if needed */
> > +               if (server->sign && !mid->decrypted) {
> > +                       int rc;
> > +                       struct smb_rqst rqst =3D {
> > +                               .rq_iov =3D &qd_io->iov[0],
> > +                               .rq_nvec =3D qd_io->iov[1].iov_len ? 2 =
: 1,
> > +                       };
> > +
> > +                       rc =3D smb2_verify_signature(&rqst, server);
> > +                       if (rc) {
> > +                               cifs_tcon_dbg(VFS, "QueryDir signature =
verification returned error =3D %d\n",
> > +                                             rc);
> > +                               qd_io->result =3D rc;
> > +                       }
> > +               }
> > +               break;
> > +       case MID_REQUEST_SUBMITTED:
> > +       case MID_RETRY_NEEDED:
> > +               qd_io->result =3D -EAGAIN;
> > +               break;
> > +       case MID_RESPONSE_MALFORMED:
> > +               credits.value =3D le16_to_cpu(shdr->CreditRequest);
> > +               credits.instance =3D server->reconnect_instance;
> > +               qd_io->result =3D smb_EIO(smb_eio_trace_read_rsp_malfor=
med);
> > +               break;
> > +       default:
> > +               qd_io->result =3D smb_EIO1(smb_eio_trace_read_mid_state=
_unknown,
> > +                                        mid->mid_state);
> > +               break;
> > +       }
> > +
> > +       if (qd_io->result && qd_io->result !=3D -ENODATA)
> > +               cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
> > +
> > +       trace_smb3_rw_credits(0, 0, qd_io->credits.value,
> > +                             server->credits, server->in_flight,
> > +                             0, cifs_trace_rw_credits_read_response_cl=
ear);
> > +       qd_io->credits.value =3D 0;
> > +       release_mid(server, mid);
> > +       trace_smb3_rw_credits(0, 0, 0,
> > +                             server->credits, server->in_flight,
> > +                             credits.value, cifs_trace_rw_credits_read=
_response_add);
> > +       add_credits(server, &credits, 0);
> > +
> > +       complete(&qd_io->done);
> > +}
> > +
> > +/*
> > + * QueryDirectory with large buffer and multi-credit support.
> > + * Uses async infrastructure but waits for completion synchronously.
> > + */
> > +int
> > +SMB2_query_directory_large(struct cifs_query_dir_io *qd_io, unsigned i=
nt buf_size)
> > +{
> > +       int rc, flags =3D 0;
> > +       char *buf;
> > +       struct smb2_hdr *shdr;
> > +       struct smb_rqst rqst =3D { .rq_iov =3D &qd_io->iov[0],
> > +                                .rq_nvec =3D SMB2_QUERY_DIRECTORY_IOV_=
SIZE };
> > +       struct TCP_Server_Info *server =3D qd_io->server;
> > +       struct cifs_tcon *tcon =3D qd_io->tcon;
> > +       unsigned int total_len;
> > +       int credit_request;
> > +
> > +       cifs_dbg(FYI, "%s: buf_size=3D%u\n", __func__, buf_size);
> > +
> > +       /* Cap buffer size to avoid kmalloc failures for very large all=
ocations.
> > +        * SMB2_MAX_QD_DATABUF_SIZE is a safe limit that stays well bel=
ow typical
> > +        * kmalloc constraints while still allowing large directory lis=
tings.
> > +        */
> > +       if (buf_size > SMB2_MAX_QD_DATABUF_SIZE)
> > +               buf_size =3D SMB2_MAX_QD_DATABUF_SIZE;
> > +
> > +       /* Allocate response buffer. Since we'll build a combined heade=
r+data buffer,
> > +        * we need space for both. We'll request a slightly smaller Out=
putBufferLength
> > +        * from the server to ensure the total response fits.
> > +        */
> > +       qd_io->combined_iov.iov_base =3D kmalloc(buf_size, GFP_KERNEL);
> > +       if (!qd_io->combined_iov.iov_base)
> > +               return -ENOMEM;
> > +       /* Store total capacity in iov_len; updated to actual data leng=
th by receive handler */
> > +       qd_io->combined_iov.iov_len =3D buf_size;
> > +
> > +       /* Initialize completion */
> > +       init_completion(&qd_io->done);
> > +
> > +       /* Request less data from server to leave room for the response=
 header.
> > +        * Use MAX_CIFS_SMALL_BUFFER_SIZE as a safety margin.
> > +        */
> > +       rc =3D SMB2_query_directory_init(qd_io->xid, tcon, server,
> > +                                      &rqst, qd_io->persistent_fid,
> > +                                      qd_io->volatile_fid, qd_io->inde=
x,
> > +                                      qd_io->srch_inf->info_level,
> > +                                      buf_size - MAX_CIFS_SMALL_BUFFER=
_SIZE);
> > +       if (rc) {
> > +               kfree(qd_io->combined_iov.iov_base);
> > +               qd_io->combined_iov.iov_base =3D NULL;
> > +               return rc;
> > +       }
> > +
> > +       if (smb3_encryption_required(tcon))
> > +               flags |=3D CIFS_TRANSFORM_REQ;
> > +
> > +       buf =3D rqst.rq_iov[0].iov_base;
> > +       total_len =3D rqst.rq_iov[0].iov_len;
> > +
> > +       shdr =3D (struct smb2_hdr *)buf;
> > +
> > +       if (qd_io->replay) {
> > +               /* Back-off before retry */
> > +               if (qd_io->cur_sleep)
> > +                       msleep(qd_io->cur_sleep);
> > +               smb2_set_replay(server, &rqst);
> > +       }
> > +
> > +       /* Set credit charge based on buffer size */
> > +       if (qd_io->credits.value > 0) {
> > +               shdr->CreditCharge =3D cpu_to_le16(DIV_ROUND_UP(buf_siz=
e,
> > +                                               SMB2_MAX_BUFFER_SIZE));
> > +               credit_request =3D le16_to_cpu(shdr->CreditCharge) + 8;
> > +               if (server->credits >=3D server->max_credits)
> > +                       shdr->CreditRequest =3D cpu_to_le16(0);
> > +               else
> > +                       shdr->CreditRequest =3D cpu_to_le16(
> > +                               min_t(int, server->max_credits -
> > +                                               server->credits, credit=
_request));
> > +
> > +               flags |=3D CIFS_HAS_CREDITS;
> > +       }
> > +
> > +       rc =3D cifs_call_async(server, &rqst,
> > +                            cifs_query_dir_receive, smb2_query_dir_cal=
lback,
> > +                            smb2_query_dir_handle_data, qd_io, flags,
> > +                            &qd_io->credits);
> > +       if (rc) {
> > +               cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
> > +               trace_smb3_query_dir_err(qd_io->xid, qd_io->persistent_=
fid,
> > +                                        tcon->tid, tcon->ses->Suid,
> > +                                        qd_io->index, 0, rc);
> > +               kfree(qd_io->combined_iov.iov_base);
> > +               qd_io->combined_iov.iov_base =3D NULL;
> > +       }
> > +
> > +       /* Free request buffer immediately after async call */
> > +       cifs_small_buf_release(buf);
> > +
> > +       if (rc)
> > +               return rc;
> > +
> > +       /* Wait for the async operation to complete */
> > +       wait_for_completion(&qd_io->done);
> > +       return qd_io->result;
> > +}
> > +
> >  /*
> >   * Readdir/FindFirst
> >   */
> > @@ -5560,12 +5739,6 @@ int SMB2_query_directory_init(const unsigned int=
 xid,
> >         req->FileNameOffset =3D
> >                 cpu_to_le16(sizeof(struct smb2_query_directory_req));
> >         req->FileNameLength =3D cpu_to_le16(len);
> > -       /*
> > -        * BB could be 30 bytes or so longer if we used SMB2 specific
> > -        * buffer lengths, but this is safe and close enough.
> > -        */
> > -       output_size =3D min_t(unsigned int, output_size, server->maxBuf=
);
> > -       output_size =3D min_t(unsigned int, output_size, 2 << 15);
> >         req->OutputBufferLength =3D cpu_to_le32(output_size);
> >
> >         iov[0].iov_base =3D (char *)req;
> > diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> > index 7b7a864520c68..843e30c1ecc61 100644
> > --- a/fs/smb/client/smb2pdu.h
> > +++ b/fs/smb/client/smb2pdu.h
> > @@ -132,6 +132,9 @@ struct share_redirect_error_context_rsp {
> >  /* Size of the minimal QueryDir response for checking if more data exi=
sts */
> >  #define SMB2_QD2_RESPONSE_SIZE 4096
> >
> > +/* max query directory data buffer size */
> > +#define SMB2_MAX_QD_DATABUF_SIZE (2 * 1024 * 1024)
> > +
> >  /*
> >   * Output buffer size for first QueryDir in Create+QD1+QD2 compound.
> >   * Accounts for shared buffer space needed for all three responses.
> > diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> > index 9de7d2fe8d466..9607e8899f7ff 100644
> > --- a/fs/smb/client/smb2proto.h
> > +++ b/fs/smb/client/smb2proto.h
> > @@ -46,6 +46,8 @@ __le32 smb2_get_lease_state(struct cifsInodeInfo *cin=
ode, unsigned int oplock);
> >  bool smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *=
server);
> >  int smb3_handle_read_data(struct TCP_Server_Info *server,
> >                           struct mid_q_entry *mid);
> > +int smb2_query_dir_handle_data(struct TCP_Server_Info *server,
> > +                              struct mid_q_entry *mid);
> >  struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *da=
ta,
> >                                         struct super_block *sb,
> >                                         const unsigned int xid,
> > @@ -197,6 +199,7 @@ int SMB2_query_directory_init(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >                               u64 volatile_fid, int index, int info_lev=
el,
> >                               unsigned int output_size);
> >  void SMB2_query_directory_free(struct smb_rqst *rqst);
> > +int SMB2_query_directory_large(struct cifs_query_dir_io *qd_io, unsign=
ed int buf_size);
> >  int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
> >                  u64 persistent_fid, u64 volatile_fid, u32 pid,
> >                  loff_t new_eof);
> > diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> > index acfbb63086ea2..54ee1317c5b12 100644
> > --- a/fs/smb/client/trace.h
> > +++ b/fs/smb/client/trace.h
> > @@ -165,6 +165,7 @@
> >         EM(cifs_trace_rw_credits_write_prepare,         "wr-prepare ") =
\
> >         EM(cifs_trace_rw_credits_write_response_add,    "wr-resp-add") =
\
> >         EM(cifs_trace_rw_credits_write_response_clear,  "wr-resp-clr") =
\
> > +       EM(cifs_trace_rw_credits_query_dir_done,        "qd-done    ") =
\
> >         E_(cifs_trace_rw_credits_zero_in_flight,        "ZERO-IN-FLT")
> >
> >  #define smb3_tcon_ref_traces                                         \
> > diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> > index 05f8099047e1a..24ccadb00f568 100644
> > --- a/fs/smb/client/transport.c
> > +++ b/fs/smb/client/transport.c
> > @@ -1134,7 +1134,7 @@ cifs_discard_remaining_data(struct TCP_Server_Inf=
o *server)
> >  }
> >
> >  static int
> > -__cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entr=
y *mid,
> > +__cifs_discard_and_dequeue(struct TCP_Server_Info *server, struct mid_=
q_entry *mid,
> >                      bool malformed)
> >  {
> >         int length;
> > @@ -1146,12 +1146,161 @@ __cifs_readv_discard(struct TCP_Server_Info *s=
erver, struct mid_q_entry *mid,
> >         return length;
> >  }
> >
> > -static int
> > -cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry =
*mid)
> > +/*
> > + * Receive handler for async QueryDirectory with multi-credit support
> > + */
> > +int
> > +cifs_query_dir_receive(struct TCP_Server_Info *server, struct mid_q_en=
try *mid)
> >  {
> > -       struct cifs_io_subrequest *rdata =3D mid->callback_data;
> > +       int length, len;
> > +       unsigned int data_offset, data_len, resp_size;
> > +       struct cifs_query_dir_io *qd_io =3D mid->callback_data;
> > +       char *buf =3D server->smallbuf;
> > +       unsigned int buflen =3D server->pdu_size;
> > +       struct smb2_query_directory_rsp *rsp;
> > +
> > +       cifs_dbg(FYI, "%s: mid=3D%llu buf_capacity=3D%zu\n",
> > +                __func__, mid->mid, qd_io->combined_iov.iov_len);
> > +
> > +       /*
> > +        * Read the rest of QUERY_DIRECTORY_RSP header (sans Data array=
).
> > +        * QueryDirectory response structure is 64 bytes (SMB2 header) =
+ 8 bytes (fixed part).
> > +        */
> > +       resp_size =3D sizeof(struct smb2_query_directory_rsp);
> > +       len =3D min_t(unsigned int, buflen, resp_size) - HEADER_SIZE(se=
rver) + 1;
> > +
> > +       length =3D cifs_read_from_socket(server,
> > +                                      buf + HEADER_SIZE(server) - 1, l=
en);
> > +       if (length < 0) {
> > +               qd_io->result =3D length;
> > +               return __cifs_discard_and_dequeue(server, mid, false);
> > +       }
> > +       server->total_read +=3D length;
> > +
> > +       if (server->ops->is_session_expired &&
> > +           server->ops->is_session_expired(buf)) {
> > +               cifs_reconnect(server, true);
> > +               return -1;
> > +       }
> > +
> > +       if (server->ops->is_status_pending &&
> > +           server->ops->is_status_pending(buf, server)) {
> > +               cifs_discard_remaining_data(server);
> > +               return -1;
> > +       }
> > +
> > +       /* Is there enough to get to the rest of the QUERY_DIRECTORY_RS=
P header? */
> > +       if (server->total_read < resp_size) {
> > +               cifs_dbg(FYI, "%s: server returned short header. got=3D=
%u expected=3D%u\n",
> > +                        __func__, server->total_read, resp_size);
> > +               qd_io->result =3D smb_EIO2(smb_eio_trace_read_rsp_short=
,
> > +                                        server->total_read, resp_size)=
;
> > +               return __cifs_discard_and_dequeue(server, mid, true);
> > +       }
> > +
> > +       /* Set up first iov for signature check and to get credits */
> > +       qd_io->iov[0].iov_base =3D buf;
> > +       qd_io->iov[0].iov_len =3D server->total_read;
> > +       qd_io->iov[1].iov_base =3D NULL;
> > +       qd_io->iov[1].iov_len =3D 0;
> > +       cifs_dbg(FYI, "0: iov_base=3D%p iov_len=3D%zu\n",
> > +                qd_io->iov[0].iov_base, qd_io->iov[0].iov_len);
> > +
> > +       /* Parse header early to access status before map_error convert=
s it */
> > +       rsp =3D (struct smb2_query_directory_rsp *)buf;
> > +
> > +       /* Was the SMB query_directory successful? */
> > +       qd_io->result =3D server->ops->map_error(buf, false);
> > +       if (qd_io->result !=3D 0) {
> > +               if (qd_io->combined_iov.iov_base && qd_io->iov[0].iov_l=
en > 0 &&
> > +                   qd_io->iov[0].iov_len <=3D qd_io->combined_iov.iov_=
len) {
> > +                       memcpy(qd_io->combined_iov.iov_base, qd_io->iov=
[0].iov_base,
> > +                              qd_io->iov[0].iov_len);
> > +                       qd_io->iov[0].iov_base =3D qd_io->combined_iov.=
iov_base;
> > +               }
> > +               cifs_dbg(FYI, "%s: server returned error %d (Status was=
 0x%x)\n",
> > +                        __func__, qd_io->result, le32_to_cpu(rsp->hdr.=
Status));
> > +               return __cifs_discard_and_dequeue(server, mid, false);
> > +       }
> > +
> > +       data_offset =3D le16_to_cpu(rsp->OutputBufferOffset);
> > +       data_len =3D le32_to_cpu(rsp->OutputBufferLength);
> > +
> > +       cifs_dbg(FYI, "%s: total_read=3D%u data_offset=3D%u data_len=3D=
%u\n",
> > +                __func__, server->total_read, data_offset, data_len);
> > +
> > +       /* Validate data_offset and data_len */
> > +       if (data_offset < server->total_read) {
> > +               cifs_dbg(FYI, "%s: data offset (%u) inside response hea=
der\n",
> > +                        __func__, data_offset);
> > +               data_offset =3D server->total_read;
> > +               data_len =3D 0;
> > +       } else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
> > +               cifs_dbg(FYI, "%s: data offset (%u) beyond end of small=
buf\n",
> > +                        __func__, data_offset);
> > +               qd_io->result =3D smb_EIO1(smb_eio_trace_read_overlarge=
,
> > +                                        data_offset);
> > +               return __cifs_discard_and_dequeue(server, mid, true);
> > +       }
> > +
> > +       /* Read any padding between header and data */
> > +       len =3D data_offset - server->total_read;
> > +       if (len > 0) {
> > +               length =3D cifs_read_from_socket(server,
> > +                                              buf + server->total_read=
, len);
> > +               if (length < 0) {
> > +                       qd_io->result =3D length;
> > +                       return __cifs_discard_and_dequeue(server, mid, =
false);
> > +               }
> > +               server->total_read +=3D length;
> > +               qd_io->iov[0].iov_len =3D server->total_read;
> > +       }
> > +
> > +       /* Check if data fits in the pre-allocated combined buffer */
> > +       if (qd_io->iov[0].iov_len + data_len > qd_io->combined_iov.iov_=
len) {
> > +               cifs_dbg(VFS, "%s: response (%zu + %u) exceeds buffer c=
apacity (%zu)\n",
> > +                        __func__, qd_io->iov[0].iov_len, data_len, qd_=
io->combined_iov.iov_len);
> > +               qd_io->result =3D smb_EIO2(smb_eio_trace_read_rsp_malfo=
rmed,
> > +                                        data_len, (unsigned int)qd_io-=
>combined_iov.iov_len);
> > +               return __cifs_discard_and_dequeue(server, mid, true);
> > +       }
> > +
> > +       /*
> > +        * Build combined header+data in qd_io->combined_iov.iov_base,
> > +        * preserving the wire layout so SMB2 signing can be verified a=
gainst
> > +        * the exact on-the-wire bytes.  hdr_len already accounts for t=
he
> > +        * header and any padding up to data_offset; data is read at th=
at
> > +        * same offset.  OutputBufferOffset/Length are left untouched.
> > +        */
> > +       if (qd_io->iov[0].iov_len > 0 && qd_io->result =3D=3D 0) {
> > +               size_t hdr_len =3D qd_io->iov[0].iov_len;
> > +
> > +               /* Copy header+padding to combined buffer, preserving w=
ire layout */
> > +               memcpy(qd_io->combined_iov.iov_base, qd_io->iov[0].iov_=
base, hdr_len);
> > +
> > +               /* Read directory entries at the wire data_offset posit=
ion */
> > +               if (data_len > 0) {
> > +                       length =3D cifs_read_from_socket(server,
> > +                                                      qd_io->combined_=
iov.iov_base + hdr_len,
> > +                                                      data_len);
> > +                       if (length < 0) {
> > +                               qd_io->result =3D length;
> > +                               return __cifs_discard_and_dequeue(serve=
r, mid, false);
> > +                       }
> > +                       server->total_read +=3D length;
> > +
> > +                       /* Set up second iov pointing to the directory =
data within combined buffer */
> > +                       qd_io->iov[1].iov_base =3D qd_io->combined_iov.=
iov_base + hdr_len;
> > +                       qd_io->iov[1].iov_len =3D length;
> > +               }
> > +
> > +               qd_io->combined_iov.iov_len =3D hdr_len + (data_len > 0=
 ? length : 0);
> > +
> > +               cifs_dbg(FYI, "total_read=3D%u buflen=3D%u data_len=3D%=
u hdr_len=3D%zu combined_len=3D%zu\n",
> > +                        server->total_read, buflen, data_len, hdr_len,=
 qd_io->combined_iov.iov_len);
> > +       }
> >
> > -       return  __cifs_readv_discard(server, mid, rdata->result);
> > +       return __cifs_discard_and_dequeue(server, mid, false);
> >  }
> >
> >  int
> > @@ -1205,7 +1354,7 @@ cifs_readv_receive(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
> >                 cifs_dbg(FYI, "%s: server returned error %d\n",
> >                          __func__, rdata->result);
> >                 /* normal error on read response */
> > -               return __cifs_readv_discard(server, mid, false);
> > +               return __cifs_discard_and_dequeue(server, mid, false);
> >         }
> >
> >         /* Is there enough to get to the rest of the READ_RSP header? *=
/
> > @@ -1215,7 +1364,7 @@ cifs_readv_receive(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
> >                          server->vals->read_rsp_size);
> >                 rdata->result =3D smb_EIO2(smb_eio_trace_read_rsp_short=
,
> >                                          server->total_read, server->va=
ls->read_rsp_size);
> > -               return cifs_readv_discard(server, mid);
> > +               return __cifs_discard_and_dequeue(server, mid, rdata->r=
esult);
> >         }
> >
> >         data_offset =3D server->ops->read_data_offset(buf);
> > @@ -1234,7 +1383,7 @@ cifs_readv_receive(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
> >                          __func__, data_offset);
> >                 rdata->result =3D smb_EIO1(smb_eio_trace_read_overlarge=
,
> >                                          data_offset);
> > -               return cifs_readv_discard(server, mid);
> > +               return __cifs_discard_and_dequeue(server, mid, rdata->r=
esult);
> >         }
> >
> >         cifs_dbg(FYI, "%s: total_read=3D%u data_offset=3D%u\n",
> > @@ -1260,7 +1409,7 @@ cifs_readv_receive(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
> >                 /* data_len is corrupt -- discard frame */
> >                 rdata->result =3D smb_EIO2(smb_eio_trace_read_rsp_malfo=
rmed,
> >                                          data_offset + data_len, buflen=
);
> > -               return cifs_readv_discard(server, mid);
> > +               return __cifs_discard_and_dequeue(server, mid, rdata->r=
esult);
> >         }
> >
> >  #ifdef CONFIG_CIFS_SMB_DIRECT
> > @@ -1279,7 +1428,7 @@ cifs_readv_receive(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
> >
> >         /* discard anything left over */
> >         if (server->total_read < buflen)
> > -               return cifs_readv_discard(server, mid);
> > +               return __cifs_discard_and_dequeue(server, mid, rdata->r=
esult);
> >
> >         dequeue_mid(server, mid, false);
> >         mid->resp_buf =3D server->smallbuf;
> > --
> > 2.43.0
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000f96a990651964a16
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-optimize-readdir-for-larger-directories.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-optimize-readdir-for-larger-directories.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mp2271uu0>
X-Attachment-Id: f_mp2271uu0

RnJvbSAyZTUxYWJkMDg3ZDQ5ZGI5MjBiY2U1N2ExNzRlMmM1ZTZmNjA2ZWIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgOSBNYXkgMjAyNiAxNDo1NTo0OSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBjaWZzOiBvcHRpbWl6ZSByZWFkZGlyIGZvciBsYXJnZXIgZGlyZWN0b3JpZXMKClRvZGF5IFF1
ZXJ5RGlyZWN0b3J5IHVzZXMgdGhlIGNvbXBvdW5kX3NlbmRfcmVjdiBpbmZyYXN0cnVjdHVyZQp3
aGljaCBpcyBsaW1pdGVkIHRvIDE2S0IgaW4gc2l6ZS4gQXMgYSByZXN1bHQsIHJlYWRkaXIgb2Yg
bGFyZ2UKZGlyZWN0b3JpZXMgZ2VuZXJhbGx5IHRha2Ugc2V2ZXJhbCByb3VuZCB0cmlwcy4KCldp
dGggdGhpcyBjaGFuZ2UsIGlmIHRoZSByZWFkZGlyIG5lZWRzIGEgUXVlcnlEaXIgYWZ0ZXIgdGhl
IGZpcnN0CnJvdW5kLXRyaXAgKG1lYW5pbmcgdGhhdCB0aGVyZSBhcmUgbW9yZSBkaXJlbnRzIHRv
IHJlYWQpLCB0aGVuIHRoZQpmb2xsb3dpbmcgUXVlcnlEaXJzIHdpbGwgbm93IHN3aXRjaCB0byB1
c2luZyBsYXJnZXIgYnVmZmVycyB3aXRoCk1UVSBjcmVkaXRzLgoKVGlsbCBub3csIHRoZSBvbmx5
IGNvbW1hbmQgdHlwZSB0aGF0IHVzZWQgdGhpcyBmbG93IHdhcyBTTUIyX1JFQUQuCkluIGNhc2Ug
b2YgZW5jcnlwdGVkIHJlc3BvbnNlLCBpdCBiZWNvbWVzIGNoYWxsZW5naW5nIHRvIGRlY2lkZSBp
Zgp0aGUgcmVzcG9uc2UgaXMgZm9yIFNNQjJfUkVBRCBvciBTTUIyX1JFQURESVIuIFRoaXMgY2hh
bmdlIHJldXNlcwpyZWNlaXZlX2VuY3J5cHRlZF9yZWFkIGFuZCBhZnRlciBkZWNyeXB0aW5nIHRo
ZSByZXNwb25zZSBkZWNpZGVzCnRoZSBoYW5kbGluZyBmdW5jdGlvbiBiYXNlZCBvbiB0aGUgY29t
bWFuZCBpbiB0aGUgcmVzcCBoZWFkZXIuIFRoYXQKd2F5LCBjYXJlIGhhcyBiZWVuIHRha2VuIHRv
IGVuc3VyZSB0aGF0IHRoZSByZWFkIGNvZGUgcGF0aAptb2RpZmljYXRpb25zIG9uIGFjY291bnQg
b2YgdGhpcyBjaGFuZ2UgYXJlIGtlcHQgdG8gYSBtaW5pbXVtLgoKQ2M6IERhdmlkIEhvd2VsbHMg
PGRob3dlbGxzQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJh
c2FkQG1pY3Jvc29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hA
bWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2NpZnNnbG9iLmggIHwgIDIxICstCiBm
cy9zbWIvY2xpZW50L2NpZnNwcm90by5oIHwgICAzICsKIGZzL3NtYi9jbGllbnQvcmVhZGRpci5j
ICAgfCAgIDIgKy0KIGZzL3NtYi9jbGllbnQvc21iMW9wcy5jICAgfCAgIDQgKy0KIGZzL3NtYi9j
bGllbnQvc21iMm1pc2MuYyAgfCAgIDcgKy0KIGZzL3NtYi9jbGllbnQvc21iMm9wcy5jICAgfCA0
NTcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0KIGZzL3NtYi9jbGllbnQv
c21iMnBkdS5jICAgfCAxODUgKysrKysrKysrKysrKystCiBmcy9zbWIvY2xpZW50L3NtYjJwZHUu
aCAgIHwgICAzICsKIGZzL3NtYi9jbGllbnQvc21iMnByb3RvLmggfCAgIDMgKwogZnMvc21iL2Ns
aWVudC90cmFjZS5oICAgICB8ICAgMSArCiBmcy9zbWIvY2xpZW50L3RyYW5zcG9ydC5jIHwgMTcw
ICsrKysrKysrKysrKysrCiAxMSBmaWxlcyBjaGFuZ2VkLCA4MjMgaW5zZXJ0aW9ucygrKSwgMzMg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oIGIvZnMv
c21iL2NsaWVudC9jaWZzZ2xvYi5oCmluZGV4IDc5ODc2YzA2MmQxZC4uYzg5NWVmN2ZkYTJiIDEw
MDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKKysrIGIvZnMvc21iL2NsaWVudC9j
aWZzZ2xvYi5oCkBAIC01MDEsNyArNTAxLDcgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlv
bnMgewogCQkJICAgICAgIHN0cnVjdCBjaWZzX3NlYXJjaF9pbmZvICopOwogCS8qIGNvbnRpbnVl
IHJlYWRkaXIgKi8KIAlpbnQgKCpxdWVyeV9kaXJfbmV4dCkoY29uc3QgdW5zaWduZWQgaW50LCBz
dHJ1Y3QgY2lmc190Y29uICosCi0JCQkgICAgICBzdHJ1Y3QgY2lmc19maWQgKiwKKwkJCSAgICAg
IHN0cnVjdCBjaWZzX3NiX2luZm8gKiwgc3RydWN0IGNpZnNfZmlkICosCiAJCQkgICAgICBfX3Ux
Niwgc3RydWN0IGNpZnNfc2VhcmNoX2luZm8gKnNyY2hfaW5mKTsKIAkvKiBjbG9zZSBkaXIgKi8K
IAlpbnQgKCpjbG9zZV9kaXIpKGNvbnN0IHVuc2lnbmVkIGludCwgc3RydWN0IGNpZnNfdGNvbiAq
LApAQCAtMTM5NCw2ICsxMzk0LDI1IEBAIHN0cnVjdCBjaWZzX3NlYXJjaF9pbmZvIHsKIAlib29s
IGlzX2R5bmFtaWNfYnVmOjE7IC8qIGR5bmFtaWNhbGx5IGFsbG9jYXRlZCBidWZmZXIgLSBjYW4g
YmUgdmFyaWFibGUgc2l6ZSAqLwogfTsKIAorLyogU3RydWN0dXJlIGZvciBRdWVyeURpcmVjdG9y
eSB3aXRoIG11bHRpLWNyZWRpdCBzdXBwb3J0ICovCitzdHJ1Y3QgY2lmc19xdWVyeV9kaXJfaW8g
eworCXN0cnVjdCBjaWZzX3Rjb24gKnRjb247CisJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2Vy
dmVyOworCXN0cnVjdCBjaWZzX3NlYXJjaF9pbmZvICpzcmNoX2luZjsKKwl1bnNpZ25lZCBpbnQg
eGlkOworCXU2NCBwZXJzaXN0ZW50X2ZpZDsKKwl1NjQgdm9sYXRpbGVfZmlkOworCWludCBpbmRl
eDsKKwlzdHJ1Y3Qga3ZlYyBjb21iaW5lZF9pb3Y7CS8qIFByZS1hbGxvY2F0ZWQgYnVmZmVyIHRv
IGhvbGQgcmVzcCAqLworCXN0cnVjdCBjb21wbGV0aW9uIGRvbmU7CisJaW50IHJlc3VsdDsKKwlz
dHJ1Y3QgY2lmc19jcmVkaXRzIGNyZWRpdHM7CisJYm9vbCByZXBsYXk7CisJdW5zaWduZWQgaW50
IHJldHJpZXM7CisJdW5zaWduZWQgaW50IGN1cl9zbGVlcDsKKwlzdHJ1Y3Qga3ZlYyBpb3ZbMl07
CQkvKiBGb3IgcmVzcG9uc2UgaGFuZGxpbmcgKi8KK307CisKICNkZWZpbmUgQUNMX05PX01PREUJ
KCh1bW9kZV90KSgtMSkpCiBzdHJ1Y3QgY2lmc19vcGVuX3Bhcm1zIHsKIAlzdHJ1Y3QgY2lmc190
Y29uICp0Y29uOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzcHJvdG8uaCBiL2ZzL3Nt
Yi9jbGllbnQvY2lmc3Byb3RvLmgKaW5kZXggNzlkODkxZjdkZjFhLi4yNTY1NWM0MmUxZGIgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmgKKysrIGIvZnMvc21iL2NsaWVudC9j
aWZzcHJvdG8uaApAQCAtMzM2LDYgKzMzNiw5IEBAIHN0cnVjdCBjaWZzX3NlcyAqY2lmc19nZXRf
c21iX3NlcyhzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiBpbnQgY2lmc19yZWFkdl9y
ZWNlaXZlKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAkJICAgICAgIHN0cnVjdCBt
aWRfcV9lbnRyeSAqbWlkKTsKIAoraW50IGNpZnNfcXVlcnlfZGlyX3JlY2VpdmUoc3RydWN0IFRD
UF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAorCQkJICAgIHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkKTsK
KwogaW50IGNpZnNfcXVlcnlfbWZfc3ltbGluayh1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAogCQkJICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAogCQkJICBj
b25zdCB1bnNpZ25lZCBjaGFyICpwYXRoLCBjaGFyICpwYnVmLApkaWZmIC0tZ2l0IGEvZnMvc21i
L2NsaWVudC9yZWFkZGlyLmMgYi9mcy9zbWIvY2xpZW50L3JlYWRkaXIuYwppbmRleCBiNTBlZmQ5
YjllMWQuLjhhNDQ0Zjk3ZTBhZSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9yZWFkZGlyLmMK
KysrIGIvZnMvc21iL2NsaWVudC9yZWFkZGlyLmMKQEAgLTc2MCw3ICs3NjAsNyBAQCBmaW5kX2Np
ZnNfZW50cnkoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwg
bG9mZl90IHBvcywKIAl3aGlsZSAoKGluZGV4X3RvX2ZpbmQgPj0gY2ZpbGUtPnNyY2hfaW5mLmlu
ZGV4X29mX2xhc3RfZW50cnkpICYmCiAJICAgICAgIChyYyA9PSAwKSAmJiAhY2ZpbGUtPnNyY2hf
aW5mLmVuZE9mU2VhcmNoKSB7CiAJCWNpZnNfZGJnKEZZSSwgImNhbGxpbmcgZmluZG5leHQyXG4i
KTsKLQkJcmMgPSBzZXJ2ZXItPm9wcy0+cXVlcnlfZGlyX25leHQoeGlkLCB0Y29uLCAmY2ZpbGUt
PmZpZCwKKwkJcmMgPSBzZXJ2ZXItPm9wcy0+cXVlcnlfZGlyX25leHQoeGlkLCB0Y29uLCBjaWZz
X3NiLCAmY2ZpbGUtPmZpZCwKIAkJCQkJCSBzZWFyY2hfZmxhZ3MsCiAJCQkJCQkgJmNmaWxlLT5z
cmNoX2luZik7CiAJCWlmIChyYykKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMW9wcy5j
IGIvZnMvc21iL2NsaWVudC9zbWIxb3BzLmMKaW5kZXggZTE5OGUzZGRhOTE3Li42YjA4NzRmYWMy
OTQgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMW9wcy5jCisrKyBiL2ZzL3NtYi9jbGll
bnQvc21iMW9wcy5jCkBAIC0xMTMyLDggKzExMzIsOCBAQCBjaWZzX3F1ZXJ5X2Rpcl9maXJzdChj
b25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCiBzdGF0aWMg
aW50CiBjaWZzX3F1ZXJ5X2Rpcl9uZXh0KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBj
aWZzX3Rjb24gKnRjb24sCi0JCSAgICBzdHJ1Y3QgY2lmc19maWQgKmZpZCwgX191MTYgc2VhcmNo
X2ZsYWdzLAotCQkgICAgc3RydWN0IGNpZnNfc2VhcmNoX2luZm8gKnNyY2hfaW5mKQorCQkgICAg
c3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNpZnNfZmlkICpmaWQsCisJCSAg
ICBfX3UxNiBzZWFyY2hfZmxhZ3MsIHN0cnVjdCBjaWZzX3NlYXJjaF9pbmZvICpzcmNoX2luZikK
IHsKIAlyZXR1cm4gQ0lGU0ZpbmROZXh0KHhpZCwgdGNvbiwgZmlkLT5uZXRmaWQsIHNlYXJjaF9m
bGFncywgc3JjaF9pbmYpOwogfQpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIybWlzYy5j
IGIvZnMvc21iL2NsaWVudC9zbWIybWlzYy5jCmluZGV4IDJhNzM1NWNlMWEwNy4uYzdhMWZkN2Q1
Yzk1IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJtaXNjLmMKKysrIGIvZnMvc21iL2Ns
aWVudC9zbWIybWlzYy5jCkBAIC0xMiw2ICsxMiw3IEBACiAjaW5jbHVkZSAiY2lmc2dsb2IuaCIK
ICNpbmNsdWRlICJjaWZzcHJvdG8uaCIKICNpbmNsdWRlICJzbWIycHJvdG8uaCIKKyNpbmNsdWRl
ICJzbWIycGR1LmgiCiAjaW5jbHVkZSAiY2lmc19kZWJ1Zy5oIgogI2luY2x1ZGUgImNpZnNfdW5p
Y29kZS5oIgogI2luY2x1ZGUgIi4uL2NvbW1vbi9zbWIyc3RhdHVzLmgiCkBAIC0zMTcsNyArMzE4
LDcgQEAgY2hhciAqCiBzbWIyX2dldF9kYXRhX2FyZWFfbGVuKGludCAqb2ZmLCBpbnQgKmxlbiwg
c3RydWN0IHNtYjJfaGRyICpzaGRyKQogewogCWNvbnN0IGludCBtYXhfb2ZmID0gNDA5NjsKLQlj
b25zdCBpbnQgbWF4X2xlbiA9IDEyOCAqIDEwMjQ7CisJaW50IG1heF9sZW4gPSAxMjggKiAxMDI0
OwogCiAJKm9mZiA9IDA7CiAJKmxlbiA9IDA7CkBAIC0zNjgsNiArMzY5LDEwIEBAIHNtYjJfZ2V0
X2RhdGFfYXJlYV9sZW4oaW50ICpvZmYsIGludCAqbGVuLCBzdHJ1Y3Qgc21iMl9oZHIgKnNoZHIp
CiAJCSAgKChzdHJ1Y3Qgc21iMl9xdWVyeV9kaXJlY3RvcnlfcnNwICopc2hkciktPk91dHB1dEJ1
ZmZlck9mZnNldCk7CiAJCSpsZW4gPSBsZTMyX3RvX2NwdSgKIAkJICAoKHN0cnVjdCBzbWIyX3F1
ZXJ5X2RpcmVjdG9yeV9yc3AgKilzaGRyKS0+T3V0cHV0QnVmZmVyTGVuZ3RoKTsKKwkJLyogQWxs
b3cgbGFyZ2VyIGJ1ZmZlcnMgZm9yIHF1ZXJ5IGRpcmVjdG9yeSAodXAgdG8gMk1CKS4KKwkJICog
VGhlIGFjdHVhbCBkYXRhIGlzIGhhbmRsZWQgc2VwYXJhdGVseSBpbiBjaWZzX3F1ZXJ5X2Rpcl9y
ZWNlaXZlKCkuCisJCSAqLworCQltYXhfbGVuID0gU01CMl9NQVhfUURfREFUQUJVRl9TSVpFOwog
CQlicmVhazsKIAljYXNlIFNNQjJfSU9DVEw6CiAJCSpvZmYgPSBsZTMyX3RvX2NwdSgKZGlmZiAt
LWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jIGIvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMK
aW5kZXggZDA0ZTU0YzVkZjMzLi43YjlhYTIxMjg5NzAgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGll
bnQvc21iMm9wcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCkBAIC0yNzIwLDExICsy
NzIwLDEzMiBAQCBzbWIyX3F1ZXJ5X2Rpcl9maXJzdChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCiBzdGF0aWMgaW50CiBzbWIyX3F1ZXJ5X2Rpcl9uZXh0
KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCi0JCSAgICBz
dHJ1Y3QgY2lmc19maWQgKmZpZCwgX191MTYgc2VhcmNoX2ZsYWdzLAotCQkgICAgc3RydWN0IGNp
ZnNfc2VhcmNoX2luZm8gKnNyY2hfaW5mKQorCQkgICAgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lm
c19zYiwgc3RydWN0IGNpZnNfZmlkICpmaWQsCisJCSAgICBfX3UxNiBzZWFyY2hfZmxhZ3MsIHN0
cnVjdCBjaWZzX3NlYXJjaF9pbmZvICpzcmNoX2luZikKIHsKLQlyZXR1cm4gU01CMl9xdWVyeV9k
aXJlY3RvcnkoeGlkLCB0Y29uLCBmaWQtPnBlcnNpc3RlbnRfZmlkLAotCQkJCSAgICBmaWQtPnZv
bGF0aWxlX2ZpZCwgMCwgc3JjaF9pbmYpOworCXN0cnVjdCBjaWZzX3F1ZXJ5X2Rpcl9pbyBxZF9p
bzsKKwlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXI7CisJc3RydWN0IGNpZnNfc2VzICpz
ZXMgPSB0Y29uLT5zZXM7CisJc2l6ZV90IGJ1Zl9zaXplOworCWludCByYzsKKwlpbnQgcmVzcF9i
dWZ0eXBlID0gQ0lGU19EWU5BTUlDX0JVRkZFUjsKKworCS8qIFBpY2sgc2VydmVyIGFuZCBkZXRl
cm1pbmUgYnVmZmVyIHNpemUgYmFzZWQgb24gbmVnb3RpYXRlZCByc2l6ZSAqLworCXNlcnZlciA9
IGNpZnNfcGlja19jaGFubmVsKHNlcyk7CisJaWYgKCFzZXJ2ZXIpCisJCXJldHVybiBzbWJfRUlP
KHNtYl9laW9fdHJhY2VfbnVsbF9wb2ludGVycyk7CisKKwkvKiBOZWdvdGlhdGUgcnNpemUgaWYg
bm90IGFscmVhZHkgc2V0ICovCisJaWYgKGNpZnNfc2ItPmN0eC0+cnNpemUgPT0gMCkKKwkJY2lm
c19uZWdvdGlhdGVfcnNpemUoc2VydmVyLCBjaWZzX3NiLT5jdHgsIHRjb24pOworCisJLyogVXNl
IG5lZ290aWF0ZWQgcnNpemUgZm9yIGJ1ZmZlciBzaXplLCB3aXRoIHJlYXNvbmFibGUgbGltaXRz
ICovCisJYnVmX3NpemUgPSBjaWZzX3NiLT5jdHgtPnJzaXplOworCisJY2lmc19kYmcoRllJLCAi
JXM6IHVzaW5nIGJ1ZmZlciBzaXplICV6dSAocnNpemU9JXUsIGVuY3J5cHRlZD0lZClcbiIsCisJ
CSBfX2Z1bmNfXywgYnVmX3NpemUsIGNpZnNfc2ItPmN0eC0+cnNpemUsIHNtYjNfZW5jcnlwdGlv
bl9yZXF1aXJlZCh0Y29uKSk7CisKKwkvKiBJbml0aWFsaXplIHFkX2lvIHN0cnVjdHVyZSAqLwor
CW1lbXNldCgmcWRfaW8sIDAsIHNpemVvZihxZF9pbykpOworCXFkX2lvLnRjb24gPSB0Y29uOwor
CXFkX2lvLnNlcnZlciA9IHNlcnZlcjsKKwlxZF9pby5zcmNoX2luZiA9IHNyY2hfaW5mOworCXFk
X2lvLnhpZCA9IHhpZDsKKwlxZF9pby5wZXJzaXN0ZW50X2ZpZCA9IGZpZC0+cGVyc2lzdGVudF9m
aWQ7CisJcWRfaW8udm9sYXRpbGVfZmlkID0gZmlkLT52b2xhdGlsZV9maWQ7CisJcWRfaW8uaW5k
ZXggPSAwOworCXFkX2lvLnJlc3VsdCA9IDA7CisJcWRfaW8ucmVwbGF5ID0gZmFsc2U7CisJcWRf
aW8ucmV0cmllcyA9IDA7CisJcWRfaW8uY3VyX3NsZWVwID0gMDsKKworCS8qIEFsbG9jYXRlIGNy
ZWRpdHMgZm9yIHRoZSBidWZmZXIgc2l6ZSAqLworCXJjID0gc2VydmVyLT5vcHMtPndhaXRfbXR1
X2NyZWRpdHMoc2VydmVyLCBidWZfc2l6ZSwgJmJ1Zl9zaXplLAorCQkJCQkgICAmcWRfaW8uY3Jl
ZGl0cyk7CisJaWYgKHJjKSB7CisJCWNpZnNfZGJnKFZGUywgIiVzOiBmYWlsZWQgdG8gZ2V0IGNy
ZWRpdHM6ICVkXG4iLCBfX2Z1bmNfXywgcmMpOworCQlyZXR1cm4gcmM7CisJfQorCisJY2lmc19k
YmcoRllJLCAiJXM6IGFsbG9jYXRlZCAldSBjcmVkaXRzIGZvciAlenUgYnl0ZXNcbiIsCisJCSBf
X2Z1bmNfXywgcWRfaW8uY3JlZGl0cy52YWx1ZSwgYnVmX3NpemUpOworCisJLyogU2VuZCBxdWVy
eSBkaXJlY3Rvcnkgd2l0aCBsYXJnZSBidWZmZXIgYW5kIHdhaXQgZm9yIGNvbXBsZXRpb24gKi8K
KwlyYyA9IFNNQjJfcXVlcnlfZGlyZWN0b3J5X2xhcmdlKCZxZF9pbywgYnVmX3NpemUpOworCWlm
IChyYykgeworCQlpZiAocmMgPT0gLUVOT0RBVEEpIHsKKwkJCWNvbnN0IHN0cnVjdCBzbWIyX2hk
ciAqaGRyID0gTlVMTDsKKworCQkJaWYgKHFkX2lvLmNvbWJpbmVkX2lvdi5pb3ZfYmFzZSkKKwkJ
CQloZHIgPSAoY29uc3Qgc3RydWN0IHNtYjJfaGRyICopcWRfaW8uY29tYmluZWRfaW92Lmlvdl9i
YXNlOworCQkJZWxzZSBpZiAocWRfaW8uaW92WzBdLmlvdl9iYXNlKQorCQkJCWhkciA9IChjb25z
dCBzdHJ1Y3Qgc21iMl9oZHIgKilxZF9pby5pb3ZbMF0uaW92X2Jhc2U7CisKKwkJCS8qCisJCQkg
KiBFTk9EQVRBIGZyb20gUVVFUllfRElSRUNUT1JZIGdlbmVyYWxseSBtZWFucyBlbnVtZXJhdGlv
biByZWFjaGVkCisJCQkgKiB0aGUgZW5kLiBUcmVhdCBpdCBhcyBlbmQtb2Ytc2VhcmNoIGV2ZW4g
aWYgdGhlIGhlYWRlciBidWZmZXIgaXMKKwkJCSAqIHVuYXZhaWxhYmxlIGluIHRoaXMgYXN5bmMg
cGF0aC4KKwkJCSAqLworCQkJaWYgKCFoZHIpIHsKKwkJCQljaWZzX2RiZyhGWUksICIlczogRU5P
REFUQSBidXQgaGRyIGlzIE5VTExcbiIsIF9fZnVuY19fKTsKKwkJCX0gZWxzZSB7CisJCQkJY2lm
c19kYmcoRllJLCAiJXM6IEVOT0RBVEEgd2l0aCBoZHItPlN0YXR1cz0weCV4IChTVEFUVVNfTk9f
TU9SRV9GSUxFUz0weCV4KVxuIiwKKwkJCQkJIF9fZnVuY19fLCBsZTMyX3RvX2NwdShoZHItPlN0
YXR1cyksCisJCQkJCSBsZTMyX3RvX2NwdShTVEFUVVNfTk9fTU9SRV9GSUxFUykpOworCQkJfQor
CisJCQlpZiAoaGRyICYmIGhkci0+U3RhdHVzID09IFNUQVRVU19OT19NT1JFX0ZJTEVTKSB7CisJ
CQkJdHJhY2Vfc21iM19xdWVyeV9kaXJfZG9uZSh4aWQsIGZpZC0+cGVyc2lzdGVudF9maWQsCisJ
CQkJCXRjb24tPnRpZCwgdGNvbi0+c2VzLT5TdWlkLCAwLCAwKTsKKwkJCQlzcmNoX2luZi0+ZW5k
T2ZTZWFyY2ggPSB0cnVlOworCQkJCXJjID0gMDsKKwkJCX0gZWxzZSB7CisJCQkJY2lmc19kYmco
RllJLCAiJXM6IEVOT0RBVEEgYnV0IFN0YXR1cyBtaXNtYXRjaCAtIG5vdCB0cmVhdGluZyBhcyBl
bmQtb2Ytc2VhcmNoXG4iLAorCQkJCQlfX2Z1bmNfXyk7CisJCQkJdHJhY2Vfc21iM19xdWVyeV9k
aXJfZXJyKHhpZCwgZmlkLT5wZXJzaXN0ZW50X2ZpZCwKKwkJCQkJdGNvbi0+dGlkLCB0Y29uLT5z
ZXMtPlN1aWQsIDAsIDAsIHJjKTsKKwkJCX0KKwkJfSBlbHNlIHsKKwkJCXRyYWNlX3NtYjNfcXVl
cnlfZGlyX2Vycih4aWQsIGZpZC0+cGVyc2lzdGVudF9maWQsCisJCQkJdGNvbi0+dGlkLCB0Y29u
LT5zZXMtPlN1aWQsIDAsIDAsIHJjKTsKKwkJfQorCQlnb3RvIHFkaXJfbmV4dF9leGl0OworCX0K
KworCS8qIFBhcnNlIHRoZSByZXNwb25zZSB1c2luZyB0aGUgY29tYmluZWQgYnVmZmVyIGJ1aWx0
IGluIHJlY2VpdmUgaGFuZGxlciAqLworCWlmIChxZF9pby5jb21iaW5lZF9pb3YuaW92X2xlbiA+
IDApIHsKKwkJcmMgPSBzbWIyX3BhcnNlX3F1ZXJ5X2RpcmVjdG9yeSh0Y29uLCAmcWRfaW8uY29t
YmluZWRfaW92LCByZXNwX2J1ZnR5cGUsCisJCQkJCQlzcmNoX2luZik7CisJCWlmIChyYykgewor
CQkJdHJhY2Vfc21iM19xdWVyeV9kaXJfZXJyKHhpZCwgZmlkLT5wZXJzaXN0ZW50X2ZpZCwKKwkJ
CQl0Y29uLT50aWQsIHRjb24tPnNlcy0+U3VpZCwgMCwgMCwgcmMpOworCQkJa2ZyZWUocWRfaW8u
Y29tYmluZWRfaW92Lmlvdl9iYXNlKTsKKwkJCXFkX2lvLmNvbWJpbmVkX2lvdi5pb3ZfYmFzZSA9
IE5VTEw7CisJCQlnb3RvIHFkaXJfbmV4dF9leGl0OworCQl9CisKKwkJLyogY29tYmluZWRfaW92
Lmlvdl9iYXNlIG93bmVyc2hpcCB0cmFuc2ZlcnJlZCB0byBzcmNoX2luZi0+bnR3cmtfYnVmX3N0
YXJ0ICovCisJCXFkX2lvLmNvbWJpbmVkX2lvdi5pb3ZfYmFzZSA9IE5VTEw7CisKKwkJdHJhY2Vf
c21iM19xdWVyeV9kaXJfZG9uZSh4aWQsIGZpZC0+cGVyc2lzdGVudF9maWQsCisJCQl0Y29uLT50
aWQsIHRjb24tPnNlcy0+U3VpZCwgMCwKKwkJCXNyY2hfaW5mLT5lbnRyaWVzX2luX2J1ZmZlcik7
CisJfQorCitxZGlyX25leHRfZXhpdDoKKwkvKiBGcmVlIHRoZSBkYXRhIGJ1ZmZlciBpZiBub3Qg
dHJhbnNmZXJyZWQgdG8gc3JjaF9pbmYgKi8KKwlrZnJlZShxZF9pby5jb21iaW5lZF9pb3YuaW92
X2Jhc2UpOworCisJLyogUmV0dXJuIGNyZWRpdHMgaWYgd2Ugc3RpbGwgaGF2ZSB0aGVtICh0aGV5
IHNob3VsZCBoYXZlIGJlZW4gY2xlYXJlZCBpbiBjYWxsYmFjaykgKi8KKwlpZiAocWRfaW8uY3Jl
ZGl0cy52YWx1ZSAhPSAwKSB7CisJCXRyYWNlX3NtYjNfcndfY3JlZGl0cygwLCAwLCAwLAorCQkJ
CSAgICAgIHNlcnZlci0+Y3JlZGl0cywgc2VydmVyLT5pbl9mbGlnaHQsCisJCQkJICAgICAgcWRf
aW8uY3JlZGl0cy52YWx1ZSwKKwkJCQkgICAgICBjaWZzX3RyYWNlX3J3X2NyZWRpdHNfcXVlcnlf
ZGlyX2RvbmUpOworCQlhZGRfY3JlZGl0cyhzZXJ2ZXIsICZxZF9pby5jcmVkaXRzLCAwKTsKKwl9
CisKKwlyZXR1cm4gcmM7CiB9CiAKIHN0YXRpYyBpbnQKQEAgLTQ4NDEsNiArNDk2MiwyNTIgQEAg
Y2lmc19jb3B5X2ZvbGlvcV90b19pdGVyKHN0cnVjdCBmb2xpb19xdWV1ZSAqZm9saW9xLCBzaXpl
X3QgZGF0YV9zaXplLAogCXJldHVybiAwOwogfQogCitzdGF0aWMgaW50CitjaWZzX2NvcHlfZm9s
aW9xX3RvX2J1ZihzdHJ1Y3QgZm9saW9fcXVldWUgKmZvbGlvcSwgc2l6ZV90IHRvdGFsX3NpemUs
CisJCQlzaXplX3Qgc2tpcCwgY2hhciAqYnVmLCBzaXplX3QgYnVmX2xlbikKK3sKKwlzaXplX3Qg
Y29waWVkID0gMDsKKworCWlmIChidWZfbGVuID4gdG90YWxfc2l6ZSAtIHNraXApCisJCWJ1Zl9s
ZW4gPSB0b3RhbF9zaXplIC0gc2tpcDsKKworCWZvciAoOyBmb2xpb3E7IGZvbGlvcSA9IGZvbGlv
cS0+bmV4dCkgeworCQlmb3IgKGludCBzID0gMDsgcyA8IGZvbGlvcV9jb3VudChmb2xpb3EpOyBz
KyspIHsKKwkJCXN0cnVjdCBmb2xpbyAqZm9saW8gPSBmb2xpb3FfZm9saW8oZm9saW9xLCBzKTsK
KwkJCXNpemVfdCBmc2l6ZSA9IGZvbGlvX3NpemUoZm9saW8pOworCQkJc2l6ZV90IGxlbiA9IHVt
aW4oZnNpemUgLSBza2lwLCBidWZfbGVuKTsKKworCQkJaWYgKGxlbiA9PSAwKQorCQkJCWJyZWFr
OworCisJCQltZW1jcHlfZnJvbV9mb2xpbyhidWYgKyBjb3BpZWQsIGZvbGlvLCBza2lwLCBsZW4p
OworCQkJY29waWVkICs9IGxlbjsKKwkJCWJ1Zl9sZW4gLT0gbGVuOworCQkJc2tpcCA9IDA7CisK
KwkJCWlmIChidWZfbGVuID09IDApCisJCQkJcmV0dXJuIDA7CisJCX0KKwl9CisKKwlyZXR1cm4g
MDsKK30KKworLyoKKyAqIEhhbmRsZSBlbmNyeXB0ZWQgUXVlcnlEaXJlY3RvcnkgcmVzcG9uc2Ug
ZGF0YS4KKyAqIENhbGxlZCBvbmx5IGZvciBlbmNyeXB0ZWQgcmVzcG9uc2VzIHdoZXJlIG1pZC0+
ZGVjcnlwdGVkID09IHRydWUuCisgKiBGb3IgdW5lbmNyeXB0ZWQgcmVzcG9uc2VzLCBjaWZzX3F1
ZXJ5X2Rpcl9yZWNlaXZlIGhhbmRsZXMgZXZlcnl0aGluZy4KKyAqCisgKiBUaGlzIGlzIHdyaXR0
ZW4gaW4gc3VjaCBhIHdheSB0aGF0IGhhbmRsZV9yZWFkX2RhdGEgZG9lcyBub3QgbmVlZCBtb2Rp
ZmljYXRpb24uCisgKgorICogYnVmOiBjb250YWlucyByZWFkX3JzcF9zaXplIGJ5dGVzIG9mIGRl
Y3J5cHRlZCByZXNwb25zZQorICogYnVmZmVyOiBjb250YWlucyAodG90YWxfbGVuIC0gcmVhZF9y
c3Bfc2l6ZSkgYnl0ZXMgb2YgZGVjcnlwdGVkIGRhdGEKKyAqCisgKiBTaW5jZSBzaXplb2Yoc3Ry
dWN0IHNtYjJfcXVlcnlfZGlyZWN0b3J5X3JzcCkgPCByZWFkX3JzcF9zaXplLAorICogdGhlIHJl
c3BvbnNlIGhlYWRlciBpcyBhbHdheXMgZnVsbHkgaW4gYnVmLiBEYXRhIG1heSBiZSBzcGxpdCBi
ZXR3ZWVuCisgKiBidWYgYW5kIGJ1ZmZlciBkZXBlbmRpbmcgb24gZGF0YV9vZmZzZXQuCisgKi8K
K3N0YXRpYyBpbnQKK2hhbmRsZV9xdWVyeV9kaXJfZGF0YShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZv
ICpzZXJ2ZXIsIHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkLAorCQkgICAgICBjaGFyICpidWYsIHVu
c2lnbmVkIGludCBidWZfbGVuLCBzdHJ1Y3QgZm9saW9fcXVldWUgKmJ1ZmZlciwKKwkJICAgICAg
dW5zaWduZWQgaW50IGJ1ZmZlcl9sZW4sIGJvb2wgaXNfb2ZmbG9hZGVkKQoreworCXN0cnVjdCBj
aWZzX3F1ZXJ5X2Rpcl9pbyAqcWRfaW8gPSBtaWQtPmNhbGxiYWNrX2RhdGE7CisJc3RydWN0IHNt
YjJfcXVlcnlfZGlyZWN0b3J5X3JzcCAqcnNwOworCXN0cnVjdCBzbWIyX2hkciAqc2hkciA9IChz
dHJ1Y3Qgc21iMl9oZHIgKilidWY7CisJdW5zaWduZWQgaW50IGRhdGFfb2Zmc2V0LCBkYXRhX2xl
bjsKKwl1bnNpZ25lZCBpbnQgaGRyX2xlbjsKKworCWNpZnNfZGJnKEZZSSwgIiVzOiBwcm9jZXNz
aW5nIGVuY3J5cHRlZCBRdWVyeURpcmVjdG9yeSByZXNwb25zZVxuIiwgX19mdW5jX18pOworCisJ
aWYgKHNoZHItPkNvbW1hbmQgIT0gU01CMl9RVUVSWV9ESVJFQ1RPUlkpIHsKKwkJY2lmc19zZXJ2
ZXJfZGJnKFZGUywgIm9ubHkgUXVlcnlEaXJlY3RvcnkgcmVzcG9uc2VzIGFyZSBzdXBwb3J0ZWRc
biIpOworCQlyZXR1cm4gLUVPUE5PVFNVUFA7CisJfQorCisJaWYgKHNlcnZlci0+b3BzLT5pc19z
ZXNzaW9uX2V4cGlyZWQgJiYKKwkgICAgc2VydmVyLT5vcHMtPmlzX3Nlc3Npb25fZXhwaXJlZChi
dWYpKSB7CisJCWlmICghaXNfb2ZmbG9hZGVkKQorCQkJY2lmc19yZWNvbm5lY3Qoc2VydmVyLCB0
cnVlKTsKKwkJcmV0dXJuIC0xOworCX0KKworCWlmIChzZXJ2ZXItPm9wcy0+aXNfc3RhdHVzX3Bl
bmRpbmcgJiYKKwkJCXNlcnZlci0+b3BzLT5pc19zdGF0dXNfcGVuZGluZyhidWYsIHNlcnZlcikp
CisJCXJldHVybiAtMTsKKworCXJzcCA9IChzdHJ1Y3Qgc21iMl9xdWVyeV9kaXJlY3RvcnlfcnNw
ICopYnVmOworCWhkcl9sZW4gPSBtaW5fdCh1bnNpZ25lZCBpbnQsIGJ1Zl9sZW4sCisJCQkgc2l6
ZW9mKHN0cnVjdCBzbWIyX3F1ZXJ5X2RpcmVjdG9yeV9yc3ApKTsKKworCS8qIE1hcCBlcnJvciBj
b2RlIGZpcnN0ICovCisJcWRfaW8tPnJlc3VsdCA9IHNlcnZlci0+b3BzLT5tYXBfZXJyb3IoYnVm
LCBmYWxzZSk7CisKKwkvKiBHZXQgZGF0YV9vZmZzZXQgZWFybHkgdG8gc2V0IHVwIGlvdiBwcm9w
ZXJseSAqLworCWRhdGFfb2Zmc2V0ID0gbGUxNl90b19jcHUocnNwLT5PdXRwdXRCdWZmZXJPZmZz
ZXQpOworCWRhdGFfbGVuID0gbGUzMl90b19jcHUocnNwLT5PdXRwdXRCdWZmZXJMZW5ndGgpOwor
CisJLyogU2V0IHVwIGZpcnN0IGlvdiB0byBwb2ludCB0byBoZWFkZXIgcG9ydGlvbiAobmVlZGVk
IGZvciBjcmVkaXRzL3NpZ25hdHVyZSkgKi8KKwlxZF9pby0+aW92WzBdLmlvdl9iYXNlID0gYnVm
OworCXFkX2lvLT5pb3ZbMF0uaW92X2xlbiA9IHFkX2lvLT5yZXN1bHQgPyBoZHJfbGVuIDogZGF0
YV9vZmZzZXQ7CisKKwlpZiAocWRfaW8tPnJlc3VsdCAhPSAwKSB7CisJCWNpZnNfZGJnKEZZSSwg
IiVzOiBzZXJ2ZXIgcmV0dXJuZWQgZXJyb3IgJWQgKFN0YXR1cz0weCV4KVxuIiwKKwkJCSBfX2Z1
bmNfXywgcWRfaW8tPnJlc3VsdCwgbGUzMl90b19jcHUocnNwLT5oZHIuU3RhdHVzKSk7CisKKwkJ
LyoKKwkJICogQ29weSBoZWFkZXIgdG8gcGVyc2lzdGVudCBjb21iaW5lZF9pb3YgYnVmZmVyIHNv
IHN0YXR1cworCQkgKiByZW1haW5zIGFjY2Vzc2libGUgYWZ0ZXIgcmVjZWl2ZSBoYW5kbGVyIHJl
dHVybnMuIGJ1ZiBpcyB0ZW1wb3JhcnkKKwkJICogYW5kIHdpbGwgYmUgZnJlZWQvcmV1c2VkLCBz
byB3ZSBjYW4ndCBsZWF2ZSBpb3ZbMF0gcG9pbnRpbmcgdG8gaXQKKwkJICovCisJCWlmIChxZF9p
by0+Y29tYmluZWRfaW92Lmlvdl9iYXNlICYmIGhkcl9sZW4gPiAwICYmCisJCSAgICBoZHJfbGVu
IDw9IHFkX2lvLT5jb21iaW5lZF9pb3YuaW92X2xlbikgeworCQkJbWVtY3B5KHFkX2lvLT5jb21i
aW5lZF9pb3YuaW92X2Jhc2UsIGJ1ZiwgaGRyX2xlbik7CisJCQlxZF9pby0+aW92WzBdLmlvdl9i
YXNlID0gcWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfYmFzZTsKKwkJCXFkX2lvLT5pb3ZbMF0uaW92
X2xlbiA9IGhkcl9sZW47CisJCQljaWZzX2RiZyhGWUksICIlczogY29waWVkIGVycm9yIHJlc3Bv
bnNlIGhlYWRlciB0byBjb21iaW5lZF9pb3ZcbiIsCisJCQkJX19mdW5jX18pOworCQl9CisKKwkJ
LyoKKwkJICogTm9ybWFsIGVycm9yIG9uIHF1ZXJ5X2RpcmVjdG9yeSByZXNwb25zZSAtIHJlc3Bv
bnNlIHJlY2VpdmVkIHN1Y2Nlc3NmdWxseSwKKwkJICogYnV0IHRoZSBjb21tYW5kIGZhaWxlZC4g
U3RvcmUgZXJyb3IgaW4gcWRfaW8tPnJlc3VsdCBmb3IgY2FsbGJhY2sKKwkJICovCisJCWlmIChp
c19vZmZsb2FkZWQpCisJCQltaWQtPm1pZF9zdGF0ZSA9IE1JRF9SRVNQT05TRV9SRUNFSVZFRDsK
KwkJZWxzZQorCQkJZGVxdWV1ZV9taWQoc2VydmVyLCBtaWQsIGZhbHNlKTsKKwkJcmV0dXJuIDA7
CisJfQorCisJLyogU3VjY2VzcyAtIHBhcnNlIHRoZSByZXNwb25zZSBkYXRhICovCisJY2lmc19k
YmcoRllJLCAiJXM6IGRhdGFfb2Zmc2V0PSV1IGRhdGFfbGVuPSV1IGJ1Zl9sZW49JXUgYnVmZmVy
X2xlbj0ldVxuIiwKKwkJIF9fZnVuY19fLCBkYXRhX29mZnNldCwgZGF0YV9sZW4sIGJ1Zl9sZW4s
IGJ1ZmZlcl9sZW4pOworCisJLyogVmFsaWRhdGUgZGF0YV9vZmZzZXQgKi8KKwlpZiAoZGF0YV9v
ZmZzZXQgPCBzaXplb2Yoc3RydWN0IHNtYjJfcXVlcnlfZGlyZWN0b3J5X3JzcCkpIHsKKwkJY2lm
c19kYmcoRllJLCAiJXM6IGRhdGEgb2Zmc2V0ICgldSkgaW5zaWRlIHJlc3BvbnNlIGhlYWRlclxu
IiwKKwkJCSBfX2Z1bmNfXywgZGF0YV9vZmZzZXQpOworCQlkYXRhX29mZnNldCA9IHNpemVvZihz
dHJ1Y3Qgc21iMl9xdWVyeV9kaXJlY3RvcnlfcnNwKTsKKwl9IGVsc2UgaWYgKGRhdGFfb2Zmc2V0
ID4gTUFYX0NJRlNfU01BTExfQlVGRkVSX1NJWkUpIHsKKwkJY2lmc19kYmcoVkZTLCAiJXM6IGRh
dGEgb2Zmc2V0ICgldSkgYmV5b25kIGVuZCBvZiBzbWFsbGJ1ZlxuIiwKKwkJCSBfX2Z1bmNfXywg
ZGF0YV9vZmZzZXQpOworCQlxZF9pby0+cmVzdWx0ID0gLUVJTzsKKwkJZGVxdWV1ZV9taWQoc2Vy
dmVyLCBtaWQsIHFkX2lvLT5yZXN1bHQpOworCQlyZXR1cm4gcWRfaW8tPnJlc3VsdDsKKwl9CisK
KwkvKiBWYWxpZGF0ZSBkYXRhX29mZnNldCBpcyB3aXRoaW4gYnVmX2xlbiArIGJ1ZmZlcl9sZW4g
Ki8KKwlpZiAoZGF0YV9vZmZzZXQgPiBidWZfbGVuICsgYnVmZmVyX2xlbikgeworCQljaWZzX2Ri
ZyhWRlMsICIlczogZGF0YSBvZmZzZXQgKCV1KSBiZXlvbmQgcmVzcG9uc2UgbGVuZ3RoICgldSlc
biIsCisJCQkgX19mdW5jX18sIGRhdGFfb2Zmc2V0LCBidWZfbGVuICsgYnVmZmVyX2xlbik7CisJ
CXFkX2lvLT5yZXN1bHQgPSAtRUlPOworCQlkZXF1ZXVlX21pZChzZXJ2ZXIsIG1pZCwgcWRfaW8t
PnJlc3VsdCk7CisJCXJldHVybiBxZF9pby0+cmVzdWx0OworCX0KKworCS8qIFZhbGlkYXRlIHJl
c3BvbnNlIGZpdHMgaW4gcHJlLWFsbG9jYXRlZCBjb21iaW5lZCBidWZmZXIgKi8KKwlpZiAoKHNp
emVfdClkYXRhX29mZnNldCArIGRhdGFfbGVuID4gcWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfbGVu
KSB7CisJCWNpZnNfZGJnKFZGUywgIiVzOiByZXNwb25zZSAoJXUgKyAldSkgZXhjZWVkcyBidWZm
ZXIgY2FwYWNpdHkgKCV6dSlcbiIsCisJCQkgX19mdW5jX18sIGRhdGFfb2Zmc2V0LCBkYXRhX2xl
biwgcWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfbGVuKTsKKwkJcWRfaW8tPnJlc3VsdCA9IC1FSU87
CisJCWRlcXVldWVfbWlkKHNlcnZlciwgbWlkLCBxZF9pby0+cmVzdWx0KTsKKwkJcmV0dXJuIHFk
X2lvLT5yZXN1bHQ7CisJfQorCisJLyogQ29weSB0aGUgcHJlZml4IHByZXNlbnQgaW4gYnVmIGlu
dG8gY29tYmluZWRfaW92LCBwcmVzZXJ2aW5nIHdpcmUgbGF5b3V0ICovCisJbWVtY3B5KHFkX2lv
LT5jb21iaW5lZF9pb3YuaW92X2Jhc2UsIGJ1ZiwgbWluKGRhdGFfb2Zmc2V0LCBidWZfbGVuKSk7
CisKKwlpZiAoZGF0YV9vZmZzZXQgPCBidWZfbGVuKSB7CisJCS8qIERhdGEgc3RhcnRzIGluIGJ1
ZiwgbWF5IGNvbnRpbnVlIGludG8gYnVmZmVyICovCisJCXVuc2lnbmVkIGludCBkYXRhX2luX2J1
ZiA9IGJ1Zl9sZW4gLSBkYXRhX29mZnNldDsKKwkJdW5zaWduZWQgaW50IGRhdGFfaW5fYnVmZmVy
OworCisJCWlmIChkYXRhX2xlbiA8PSBkYXRhX2luX2J1ZikgeworCQkJLyogQWxsIGRhdGEgaXMg
aW4gYnVmICovCisJCQltZW1jcHkocWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfYmFzZSArIGRhdGFf
b2Zmc2V0LAorCQkJICAgICAgIGJ1ZiArIGRhdGFfb2Zmc2V0LCBkYXRhX2xlbik7CisJCX0gZWxz
ZSB7CisJCQkvKiBDb3B5IGZyb20gYnVmIGZpcnN0ICovCisJCQltZW1jcHkocWRfaW8tPmNvbWJp
bmVkX2lvdi5pb3ZfYmFzZSArIGRhdGFfb2Zmc2V0LAorCQkJICAgICAgIGJ1ZiArIGRhdGFfb2Zm
c2V0LCBkYXRhX2luX2J1Zik7CisKKwkJCS8qIENvcHkgcmVtYWluZGVyIGZyb20gYnVmZmVyIGF0
IG9mZnNldCAwICovCisJCQlkYXRhX2luX2J1ZmZlciA9IGRhdGFfbGVuIC0gZGF0YV9pbl9idWY7
CisJCQlpZiAoZGF0YV9pbl9idWZmZXIgPiBidWZmZXJfbGVuKSB7CisJCQkJY2lmc19kYmcoVkZT
LCAiJXM6IGRhdGFfaW5fYnVmZmVyICgldSkgPiBidWZmZXJfbGVuICgldSlcbiIsCisJCQkJCSBf
X2Z1bmNfXywgZGF0YV9pbl9idWZmZXIsIGJ1ZmZlcl9sZW4pOworCQkJCXFkX2lvLT5yZXN1bHQg
PSAtRUlPOworCQkJCWRlcXVldWVfbWlkKHNlcnZlciwgbWlkLCBxZF9pby0+cmVzdWx0KTsKKwkJ
CQlyZXR1cm4gcWRfaW8tPnJlc3VsdDsKKwkJCX0KKworCQkJcWRfaW8tPnJlc3VsdCA9IGNpZnNf
Y29weV9mb2xpb3FfdG9fYnVmKGJ1ZmZlciwgYnVmZmVyX2xlbiwgMCwKKwkJCQkJCQkJcWRfaW8t
PmNvbWJpbmVkX2lvdi5pb3ZfYmFzZSArCisJCQkJCQkJCWRhdGFfb2Zmc2V0ICsgZGF0YV9pbl9i
dWYsCisJCQkJCQkJCWRhdGFfaW5fYnVmZmVyKTsKKwkJCWlmIChxZF9pby0+cmVzdWx0ICE9IDAp
IHsKKwkJCQljaWZzX2RiZyhWRlMsICIlczogZmFpbGVkIHRvIGNvcHkgZnJvbSBmb2xpb19xdWV1
ZTogJWRcbiIsCisJCQkJCSBfX2Z1bmNfXywgcWRfaW8tPnJlc3VsdCk7CisJCQkJZGVxdWV1ZV9t
aWQoc2VydmVyLCBtaWQsIHFkX2lvLT5yZXN1bHQpOworCQkJCXJldHVybiBxZF9pby0+cmVzdWx0
OworCQkJfQorCQl9CisJfSBlbHNlIHsKKwkJLyogUGFkZGluZyBhbmQgZGF0YSBhcmUgaW4gYnVm
ZmVyIHN0YXJ0aW5nIGF0IG9mZnNldCAwICovCisJCXVuc2lnbmVkIGludCBieXRlc19pbl9idWZm
ZXIgPSBkYXRhX29mZnNldCAtIGJ1Zl9sZW4gKyBkYXRhX2xlbjsKKworCQlpZiAoYnl0ZXNfaW5f
YnVmZmVyID4gYnVmZmVyX2xlbikgeworCQkJY2lmc19kYmcoVkZTLCAiJXM6IGRhdGEgYmV5b25k
IGJ1ZmZlcjogcHJlZml4K2xlbj0ldSBidWZmZXJfbGVuPSV1XG4iLAorCQkJCSBfX2Z1bmNfXywg
Ynl0ZXNfaW5fYnVmZmVyLCBidWZmZXJfbGVuKTsKKwkJCXFkX2lvLT5yZXN1bHQgPSAtRUlPOwor
CQkJZGVxdWV1ZV9taWQoc2VydmVyLCBtaWQsIHFkX2lvLT5yZXN1bHQpOworCQkJcmV0dXJuIHFk
X2lvLT5yZXN1bHQ7CisJCX0KKworCQlxZF9pby0+cmVzdWx0ID0gY2lmc19jb3B5X2ZvbGlvcV90
b19idWYoYnVmZmVyLCBidWZmZXJfbGVuLCAwLAorCQkJCQkJCXFkX2lvLT5jb21iaW5lZF9pb3Yu
aW92X2Jhc2UgKyBidWZfbGVuLAorCQkJCQkJCWJ5dGVzX2luX2J1ZmZlcik7CisJCWlmIChxZF9p
by0+cmVzdWx0ICE9IDApIHsKKwkJCWNpZnNfZGJnKFZGUywgIiVzOiBmYWlsZWQgdG8gY29weSBm
cm9tIGZvbGlvX3F1ZXVlOiAlZFxuIiwKKwkJCQkgX19mdW5jX18sIHFkX2lvLT5yZXN1bHQpOwor
CQkJZGVxdWV1ZV9taWQoc2VydmVyLCBtaWQsIHFkX2lvLT5yZXN1bHQpOworCQkJcmV0dXJuIHFk
X2lvLT5yZXN1bHQ7CisJCX0KKwl9CisKKwkvKiBTZXQgdXAgaW92WzFdIHBvaW50aW5nIGludG8g
Y29tYmluZWQgYnVmZmVyLCBmaW5hbGl6ZSB2YWxpZCBsZW5ndGggKi8KKwlxZF9pby0+aW92WzFd
Lmlvdl9iYXNlID0gcWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfYmFzZSArIGRhdGFfb2Zmc2V0Owor
CXFkX2lvLT5pb3ZbMV0uaW92X2xlbiA9IGRhdGFfbGVuOworCXFkX2lvLT5jb21iaW5lZF9pb3Yu
aW92X2xlbiA9IGRhdGFfb2Zmc2V0ICsgZGF0YV9sZW47CisKKwlkZXF1ZXVlX21pZChzZXJ2ZXIs
IG1pZCwgZmFsc2UpOworCXJldHVybiAwOworfQorCisvKgorICogSGFuZGxlIGNhbGxiYWNrIGZv
ciBhc3luYyBRdWVyeURpcmVjdG9yeSB3aXRoIG11bHRpLWNyZWRpdCBzdXBwb3J0LgorICogRm9y
IGVuY3J5cHRlZCByZXNwb25zZXMsIGV4dHJhY3RzIGRlY3J5cHRlZCBkYXRhLgorICogRm9yIHVu
ZW5jcnlwdGVkIHJlc3BvbnNlcywgY2lmc19xdWVyeV9kaXJfcmVjZWl2ZSBhbHJlYWR5IHByb2Nl
c3NlZCBldmVyeXRoaW5nLgorICovCitpbnQKK3NtYjJfcXVlcnlfZGlyX2hhbmRsZV9kYXRhKHN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgc3RydWN0IG1pZF9xX2VudHJ5ICptaWQpCit7
CisJY2hhciAqYnVmID0gc2VydmVyLT5sYXJnZV9idWYgPyBzZXJ2ZXItPmJpZ2J1ZiA6IHNlcnZl
ci0+c21hbGxidWY7CisKKwkvKiBGb3IgdW5lbmNyeXB0ZWQgcmVzcG9uc2VzLCBkYXRhIGFscmVh
ZHkgcHJvY2Vzc2VkIGluIGNpZnNfcXVlcnlfZGlyX3JlY2VpdmUgKi8KKwlpZiAoIW1pZC0+ZGVj
cnlwdGVkKQorCQlyZXR1cm4gMDsKKworCS8qCisJICogRm9yIHNtYWxsIGVuY3J5cHRlZCByZXNw
b25zZXMgKDwgQ0lGU01heEJ1ZlNpemUpLCBhbGwgZGF0YSBpcyBpbiBidWYuCisJICogRm9yIGxh
cmdlIGVuY3J5cHRlZCByZXNwb25zZXMsIHRoaXMgY2FsbGJhY2sgaXMgbm90IHVzZWQgLSBpbnN0
ZWFkLAorCSAqIHJlY2VpdmVfZW5jcnlwdGVkX3JlYWQvc21iMl9kZWNyeXB0X29mZmxvYWQgY2Fs
bCBoYW5kbGVfcXVlcnlfZGlyX2RhdGEgZGlyZWN0bHkuCisJICovCisJcmV0dXJuIGhhbmRsZV9x
dWVyeV9kaXJfZGF0YShzZXJ2ZXIsIG1pZCwgYnVmLCBzZXJ2ZXItPnBkdV9zaXplLAorCQkJCSAg
ICAgIE5VTEwsIDAsIGZhbHNlKTsKK30KKwogc3RhdGljIGludAogaGFuZGxlX3JlYWRfZGF0YShz
dHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkLAog
CQkgY2hhciAqYnVmLCB1bnNpZ25lZCBpbnQgYnVmX2xlbiwgc3RydWN0IGZvbGlvX3F1ZXVlICpi
dWZmZXIsCkBAIC01MDA0LDI1ICs1MzcxLDQ2IEBAIHN0YXRpYyB2b2lkIHNtYjJfZGVjcnlwdF9v
ZmZsb2FkKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAlpbnQgcmM7CiAJc3RydWN0IG1pZF9x
X2VudHJ5ICptaWQ7CiAJc3RydWN0IGlvdl9pdGVyIGl0ZXI7CisJc3RydWN0IHNtYjJfaGRyICpz
aGRyOworCXVuc2lnbmVkIGludCByZWFkX3JzcF9zaXplID0gZHctPnNlcnZlci0+dmFscy0+cmVh
ZF9yc3Bfc2l6ZTsKIAorCS8qIGRlY3J5cHQgcmVhZF9yc3Bfc2l6ZSBpbiBidWYgKyByZW1haW5k
ZXIgaW4gZm9saW9fcXVldWUgKi8KIAlpb3ZfaXRlcl9mb2xpb19xdWV1ZSgmaXRlciwgSVRFUl9E
RVNULCBkdy0+YnVmZmVyLCAwLCAwLCBkdy0+bGVuKTsKLQlyYyA9IGRlY3J5cHRfcmF3X2RhdGEo
ZHctPnNlcnZlciwgZHctPmJ1ZiwgZHctPnNlcnZlci0+dmFscy0+cmVhZF9yc3Bfc2l6ZSwKLQkJ
CSAgICAgICZpdGVyLCB0cnVlKTsKKwlyYyA9IGRlY3J5cHRfcmF3X2RhdGEoZHctPnNlcnZlciwg
ZHctPmJ1ZiwgcmVhZF9yc3Bfc2l6ZSwgJml0ZXIsIHRydWUpOwogCWlmIChyYykgewogCQljaWZz
X2RiZyhWRlMsICJlcnJvciBkZWNyeXB0aW5nIHJjPSVkXG4iLCByYyk7CiAJCWdvdG8gZnJlZV9w
YWdlczsKIAl9CiAKIAlkdy0+c2VydmVyLT5sc3RycCA9IGppZmZpZXM7CisKKwlzaGRyID0gKHN0
cnVjdCBzbWIyX2hkciAqKShkdy0+YnVmICsgc2l6ZW9mKHN0cnVjdCBzbWIyX3RyYW5zZm9ybV9o
ZHIpKTsKKworCS8qCisJICogYnVmIG5vdyBjb250YWlucyByZWFkX3JzcF9zaXplIGJ5dGVzIGFm
dGVyIHRyYW5zZm9ybV9oZHIuCisJICogZm9saW9fcXVldWUgY29udGFpbnMgKHRvdGFsX2xlbiAt
IHJlYWRfcnNwX3NpemUpIGJ5dGVzLgorCSAqIFRoZSBoYW5kbGUgZnVuY3Rpb25zIHdpbGwgZGV0
ZXJtaW5lIHdoZXJlIGRhdGEgYWN0dWFsbHkgc3RhcnRzIGJhc2VkIG9uIGRhdGFfb2Zmc2V0Lgor
CSAqLworCiAJbWlkID0gc21iMl9maW5kX2RlcXVldWVfbWlkKGR3LT5zZXJ2ZXIsIGR3LT5idWYp
OwogCWlmIChtaWQgPT0gTlVMTCkKIAkJY2lmc19kYmcoRllJLCAibWlkIG5vdCBmb3VuZFxuIik7
CiAJZWxzZSB7CiAJCW1pZC0+ZGVjcnlwdGVkID0gdHJ1ZTsKLQkJcmMgPSBoYW5kbGVfcmVhZF9k
YXRhKGR3LT5zZXJ2ZXIsIG1pZCwgZHctPmJ1ZiwKLQkJCQkgICAgICBkdy0+c2VydmVyLT52YWxz
LT5yZWFkX3JzcF9zaXplLAotCQkJCSAgICAgIGR3LT5idWZmZXIsIGR3LT5sZW4sCi0JCQkJICAg
ICAgdHJ1ZSk7CisKKwkJLyogSGFuZGxlIGJhc2VkIG9uIGNvbW1hbmQgdHlwZSAqLworCQlpZiAo
c2hkci0+Q29tbWFuZCA9PSBTTUIyX1JFQUQpIHsKKwkJCXJjID0gaGFuZGxlX3JlYWRfZGF0YShk
dy0+c2VydmVyLCBtaWQsIGR3LT5idWYsIHJlYWRfcnNwX3NpemUsCisJCQkJCSAgICAgIGR3LT5i
dWZmZXIsIGR3LT5sZW4sIHRydWUpOworCQl9IGVsc2UgaWYgKHNoZHItPkNvbW1hbmQgPT0gU01C
Ml9RVUVSWV9ESVJFQ1RPUlkpIHsKKwkJCXJjID0gaGFuZGxlX3F1ZXJ5X2Rpcl9kYXRhKGR3LT5z
ZXJ2ZXIsIG1pZCwgZHctPmJ1ZiwgcmVhZF9yc3Bfc2l6ZSwKKwkJCQkJCSAgIGR3LT5idWZmZXIs
IGR3LT5sZW4sIHRydWUpOworCQl9IGVsc2UgeworCQkJY2lmc19kYmcoVkZTLCAiVW5leHBlY3Rl
ZCBjb21tYW5kICV1IGluIGRlY3J5cHQgb2ZmbG9hZFxuIiwKKwkJCQkgbGUxNl90b19jcHUoc2hk
ci0+Q29tbWFuZCkpOworCQkJcmMgPSAtRU9QTk9UU1VQUDsKKwkJfQorCiAJCWlmIChyYyA+PSAw
KSB7CiAjaWZkZWYgQ09ORklHX0NJRlNfU1RBVFMyCiAJCQltaWQtPndoZW5fcmVjZWl2ZWQgPSBq
aWZmaWVzOwpAQCAtNTA2Niw5ICs1NDU0LDEwIEBAIHJlY2VpdmVfZW5jcnlwdGVkX3JlYWQoc3Ry
dWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3QgbWlkX3FfZW50cnkgKiptaWQsCiB7
CiAJY2hhciAqYnVmID0gc2VydmVyLT5zbWFsbGJ1ZjsKIAlzdHJ1Y3Qgc21iMl90cmFuc2Zvcm1f
aGRyICp0cl9oZHIgPSAoc3RydWN0IHNtYjJfdHJhbnNmb3JtX2hkciAqKWJ1ZjsKKwlzdHJ1Y3Qg
c21iMl9oZHIgKnNoZHI7CiAJc3RydWN0IGlvdl9pdGVyIGl0ZXI7Ci0JdW5zaWduZWQgaW50IGxl
bjsKLQl1bnNpZ25lZCBpbnQgYnVmbGVuID0gc2VydmVyLT5wZHVfc2l6ZTsKKwl1bnNpZ25lZCBp
bnQgbGVuLCB0b3RhbF9sZW4sIGJ1ZmxlbiA9IHNlcnZlci0+cGR1X3NpemU7CisJdW5zaWduZWQg
aW50IHJlYWRfcnNwX3NpemUgPSBzZXJ2ZXItPnZhbHMtPnJlYWRfcnNwX3NpemU7CiAJaW50IHJj
OwogCXN0cnVjdCBzbWIyX2RlY3J5cHRfd29yayAqZHc7CiAKQEAgLTUwNzksNyArNTQ2OCwxMCBA
QCByZWNlaXZlX2VuY3J5cHRlZF9yZWFkKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwg
c3RydWN0IG1pZF9xX2VudHJ5ICoqbWlkLAogCWR3LT5zZXJ2ZXIgPSBzZXJ2ZXI7CiAKIAkqbnVt
X21pZHMgPSAxOwotCWxlbiA9IG1pbl90KHVuc2lnbmVkIGludCwgYnVmbGVuLCBzZXJ2ZXItPnZh
bHMtPnJlYWRfcnNwX3NpemUgKworCXRvdGFsX2xlbiA9IGxlMzJfdG9fY3B1KHRyX2hkci0+T3Jp
Z2luYWxNZXNzYWdlU2l6ZSk7CisKKwkvKiBSZWFkIHRyYW5zZm9ybV9oZHIgKyByZWFkX3JzcF9z
aXplIGludG8gYnVmICovCisJbGVuID0gbWluX3QodW5zaWduZWQgaW50LCBidWZsZW4sIHJlYWRf
cnNwX3NpemUgKwogCQlzaXplb2Yoc3RydWN0IHNtYjJfdHJhbnNmb3JtX2hkcikpIC0gSEVBREVS
X1NJWkUoc2VydmVyKSArIDE7CiAKIAlyYyA9IGNpZnNfcmVhZF9mcm9tX3NvY2tldChzZXJ2ZXIs
IGJ1ZiArIEhFQURFUl9TSVpFKHNlcnZlcikgLSAxLCBsZW4pOwpAQCAtNTA5Nyw3ICs1NDg5LDgg
QEAgcmVjZWl2ZV9lbmNyeXB0ZWRfcmVhZChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIs
IHN0cnVjdCBtaWRfcV9lbnRyeSAqKm1pZCwKIAl9CiAJbGVuID0gbGUzMl90b19jcHUodHJfaGRy
LT5PcmlnaW5hbE1lc3NhZ2VTaXplKSAtCiAJCXNlcnZlci0+dmFscy0+cmVhZF9yc3Bfc2l6ZTsK
LQlkdy0+bGVuID0gbGVuOworCS8qIFJlYWQgcmVtYWluaW5nIGRhdGEgaW50byBmb2xpb19xdWV1
ZSAqLworCWR3LT5sZW4gPSB0b3RhbF9sZW4gLSByZWFkX3JzcF9zaXplOwogCWxlbiA9IHJvdW5k
X3VwKGR3LT5sZW4sIFBBR0VfU0laRSk7CiAKIAlzaXplX3QgY3VyX3NpemUgPSAwOwpAQCAtNTEy
Niw3ICs1NTE5LDcgQEAgcmVjZWl2ZV9lbmNyeXB0ZWRfcmVhZChzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvICpzZXJ2ZXIsIHN0cnVjdCBtaWRfcV9lbnRyeSAqKm1pZCwKIAkJZ290byBmcmVlX3BhZ2Vz
OwogCiAJLyoKLQkgKiBGb3IgbGFyZ2UgcmVhZHMsIG9mZmxvYWQgdG8gZGlmZmVyZW50IHRocmVh
ZCBmb3IgYmV0dGVyIHBlcmZvcm1hbmNlLAorCSAqIEZvciBsYXJnZSByZXNwb25zZXMsIG9mZmxv
YWQgdG8gZGlmZmVyZW50IHRocmVhZCBmb3IgYmV0dGVyIHBlcmZvcm1hbmNlLAogCSAqIHVzZSBt
b3JlIGNvcmVzIGRlY3J5cHRpbmcgd2hpY2ggY2FuIGJlIGV4cGVuc2l2ZQogCSAqLwogCkBAIC01
MTQwLDIwICs1NTMzLDQxIEBAIHJlY2VpdmVfZW5jcnlwdGVkX3JlYWQoc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3QgbWlkX3FfZW50cnkgKiptaWQsCiAJCXJldHVybiAtMTsK
IAl9CiAKLQlyYyA9IGRlY3J5cHRfcmF3X2RhdGEoc2VydmVyLCBidWYsIHNlcnZlci0+dmFscy0+
cmVhZF9yc3Bfc2l6ZSwKLQkJCSAgICAgICZpdGVyLCBmYWxzZSk7CisJLyogRGVjcnlwdDogcmVh
ZF9yc3Bfc2l6ZSBpbiBidWYgKyByZW1haW5kZXIgaW4gZm9saW9fcXVldWUgKi8KKwlyYyA9IGRl
Y3J5cHRfcmF3X2RhdGEoc2VydmVyLCBidWYsIHJlYWRfcnNwX3NpemUsICZpdGVyLCBmYWxzZSk7
CiAJaWYgKHJjKQogCQlnb3RvIGZyZWVfcGFnZXM7CiAKKwlzaGRyID0gKHN0cnVjdCBzbWIyX2hk
ciAqKSBidWY7CisKKwkvKgorCSAqIGJ1ZiBub3cgY29udGFpbnMgdGhlIGNvbXBsZXRlIHJlc3Bv
bnNlIGhlYWRlciAocmVhZF9yc3Bfc2l6ZSBieXRlcykuCisJICogZm9saW9fcXVldWUgY29udGFp
bnMgKHRvdGFsX2xlbiAtIHJlYWRfcnNwX3NpemUpIGJ5dGVzLgorCSAqIFRoZSBoYW5kbGUgZnVu
Y3Rpb25zIHdpbGwgZGV0ZXJtaW5lIHdoZXJlIGRhdGEgYWN0dWFsbHkgc3RhcnRzIGJhc2VkIG9u
IGRhdGFfb2Zmc2V0LgorCSAqLworCiAJKm1pZCA9IHNtYjJfZmluZF9taWQoc2VydmVyLCBidWYp
OwogCWlmICgqbWlkID09IE5VTEwpIHsKIAkJY2lmc19kYmcoRllJLCAibWlkIG5vdCBmb3VuZFxu
Iik7CiAJfSBlbHNlIHsKLQkJY2lmc19kYmcoRllJLCAibWlkIGZvdW5kXG4iKTsKKwkJY2lmc19k
YmcoRllJLCAibWlkIGZvdW5kLCBjb21tYW5kPSV1XG4iLCBsZTE2X3RvX2NwdShzaGRyLT5Db21t
YW5kKSk7CiAJCSgqbWlkKS0+ZGVjcnlwdGVkID0gdHJ1ZTsKLQkJcmMgPSBoYW5kbGVfcmVhZF9k
YXRhKHNlcnZlciwgKm1pZCwgYnVmLAotCQkJCSAgICAgIHNlcnZlci0+dmFscy0+cmVhZF9yc3Bf
c2l6ZSwKLQkJCQkgICAgICBkdy0+YnVmZmVyLCBkdy0+bGVuLCBmYWxzZSk7CisKKwkJLyogSGFu
ZGxlIGJhc2VkIG9uIGNvbW1hbmQgdHlwZSAqLworCQlpZiAoc2hkci0+Q29tbWFuZCA9PSBTTUIy
X1JFQUQpIHsKKwkJCXJjID0gaGFuZGxlX3JlYWRfZGF0YShzZXJ2ZXIsICptaWQsIGJ1ZiwgcmVh
ZF9yc3Bfc2l6ZSwKKwkJCQkJICAgICAgZHctPmJ1ZmZlciwgZHctPmxlbiwgZmFsc2UpOworCQl9
IGVsc2UgaWYgKHNoZHItPkNvbW1hbmQgPT0gU01CMl9RVUVSWV9ESVJFQ1RPUlkpIHsKKwkJCXJj
ID0gaGFuZGxlX3F1ZXJ5X2Rpcl9kYXRhKHNlcnZlciwgKm1pZCwgYnVmLCByZWFkX3JzcF9zaXpl
LAorCQkJCQkJICAgZHctPmJ1ZmZlciwgZHctPmxlbiwgZmFsc2UpOworCQl9IGVsc2UgeworCQkJ
LyogRm9yIG5vdywgb3RoZXIgY29tbWFuZHMgbm90IHN1cHBvcnRlZCBpbiBsYXJnZSBlbmNyeXB0
ZWQgcGF0aCAqLworCQkJY2lmc19zZXJ2ZXJfZGJnKFZGUywKKwkJCQkJIkxhcmdlIGVuY3J5cHRl
ZCByZXNwb25zZXMgb25seSBzdXBwb3J0ZWQgZm9yIFNNQjJfUkVBRCBhbmQgU01CMl9RVUVSWV9E
SVJFQ1RPUlkgKGdvdCAldSlcbiIsCisJCQkJCWxlMTZfdG9fY3B1KHNoZHItPkNvbW1hbmQpKTsK
KwkJCXJjID0gLUVPUE5PVFNVUFA7CisJCX0KKwogCQlpZiAocmMgPj0gMCkgewogCQkJaWYgKHNl
cnZlci0+b3BzLT5pc19uZXR3b3JrX25hbWVfZGVsZXRlZCkgewogCQkJCXNlcnZlci0+b3BzLT5p
c19uZXR3b3JrX25hbWVfZGVsZXRlZChidWYsCkBAIC01Mjk0LDcgKzU3MDgsNiBAQCBzbWIzX3Jl
Y2VpdmVfdHJhbnNmb3JtKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAkJcmV0dXJu
IC1FQ09OTkFCT1JURUQ7CiAJfQogCi0JLyogVE9ETzogYWRkIHN1cHBvcnQgZm9yIGNvbXBvdW5k
cyBjb250YWluaW5nIFJFQUQuICovCiAJaWYgKHBkdV9sZW5ndGggPiBDSUZTTWF4QnVmU2l6ZSAr
IE1BWF9IRUFERVJfU0laRShzZXJ2ZXIpKSB7CiAJCXJldHVybiByZWNlaXZlX2VuY3J5cHRlZF9y
ZWFkKHNlcnZlciwgJm1pZHNbMF0sIG51bV9taWRzKTsKIAl9CmRpZmYgLS1naXQgYS9mcy9zbWIv
Y2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCmluZGV4IGViNDcxMjEz
ZGY0Ni4uNjFlZTYzOWI2NGRlIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwor
KysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpAQCAtNTUwNiw2ICs1NTA2LDE4NSBAQCBudW1f
ZW50cmllcyhpbnQgaW5mb3R5cGUsIGNoYXIgKmJ1ZnN0YXJ0LCBjaGFyICplbmRfb2ZfYnVmLCBj
aGFyICoqbGFzdGVudHJ5LAogCXJldHVybiBlbnRyeWNvdW50OwogfQogCisvKgorICogQ2FsbGJh
Y2sgZm9yIGFzeW5jIFF1ZXJ5RGlyZWN0b3J5IHdpdGggbXVsdGktY3JlZGl0IHN1cHBvcnQKKyAq
Lworc3RhdGljIHZvaWQKK3NtYjJfcXVlcnlfZGlyX2NhbGxiYWNrKHN0cnVjdCBUQ1BfU2VydmVy
X0luZm8gKnNlcnZlciwgc3RydWN0IG1pZF9xX2VudHJ5ICptaWQpCit7CisJc3RydWN0IGNpZnNf
cXVlcnlfZGlyX2lvICpxZF9pbyA9IG1pZC0+Y2FsbGJhY2tfZGF0YTsKKwlzdHJ1Y3QgY2lmc190
Y29uICp0Y29uID0gcWRfaW8tPnRjb247CisJc3RydWN0IHNtYjJfaGRyICpzaGRyID0gKHN0cnVj
dCBzbWIyX2hkciAqKXFkX2lvLT5pb3ZbMF0uaW92X2Jhc2U7CisJc3RydWN0IGNpZnNfY3JlZGl0
cyBjcmVkaXRzID0geworCQkudmFsdWUgPSAwLAorCQkuaW5zdGFuY2UgPSAwLAorCX07CisKKwlX
QVJOX09OQ0UocWRfaW8tPnNlcnZlciAhPSBzZXJ2ZXIsCisJCSAgInFkX2lvIHNlcnZlciAlcCAh
PSBtaWQgc2VydmVyICVwIiwKKwkJICBxZF9pby0+c2VydmVyLCBzZXJ2ZXIpOworCisJY2lmc19k
YmcoRllJLCAiJXM6IG1pZD0lbGx1IHN0YXRlPSVkIHJlc3VsdD0lZFxuIiwKKwkJIF9fZnVuY19f
LCBtaWQtPm1pZCwgbWlkLT5taWRfc3RhdGUsIHFkX2lvLT5yZXN1bHQpOworCisJc3dpdGNoICht
aWQtPm1pZF9zdGF0ZSkgeworCWNhc2UgTUlEX1JFU1BPTlNFX1JFQ0VJVkVEOgorCQljcmVkaXRz
LnZhbHVlID0gbGUxNl90b19jcHUoc2hkci0+Q3JlZGl0UmVxdWVzdCk7CisJCWNyZWRpdHMuaW5z
dGFuY2UgPSBzZXJ2ZXItPnJlY29ubmVjdF9pbnN0YW5jZTsKKwkJLyogcmVzdWx0IGFscmVhZHkg
c2V0LCBjaGVjayBzaWduYXR1cmUgaWYgbmVlZGVkICovCisJCWlmIChzZXJ2ZXItPnNpZ24gJiYg
IW1pZC0+ZGVjcnlwdGVkKSB7CisJCQlpbnQgcmM7CisJCQlzdHJ1Y3Qgc21iX3Jxc3QgcnFzdCA9
IHsKKwkJCQkucnFfaW92ID0gJnFkX2lvLT5pb3ZbMF0sCisJCQkJLnJxX252ZWMgPSBxZF9pby0+
aW92WzFdLmlvdl9sZW4gPyAyIDogMSwKKwkJCX07CisKKwkJCXJjID0gc21iMl92ZXJpZnlfc2ln
bmF0dXJlKCZycXN0LCBzZXJ2ZXIpOworCQkJaWYgKHJjKSB7CisJCQkJY2lmc190Y29uX2RiZyhW
RlMsICJRdWVyeURpciBzaWduYXR1cmUgdmVyaWZpY2F0aW9uIHJldHVybmVkIGVycm9yID0gJWRc
biIsCisJCQkJCSAgICAgIHJjKTsKKwkJCQlxZF9pby0+cmVzdWx0ID0gcmM7CisJCQl9CisJCX0K
KwkJYnJlYWs7CisJY2FzZSBNSURfUkVRVUVTVF9TVUJNSVRURUQ6CisJY2FzZSBNSURfUkVUUllf
TkVFREVEOgorCQlxZF9pby0+cmVzdWx0ID0gLUVBR0FJTjsKKwkJYnJlYWs7CisJY2FzZSBNSURf
UkVTUE9OU0VfTUFMRk9STUVEOgorCQljcmVkaXRzLnZhbHVlID0gbGUxNl90b19jcHUoc2hkci0+
Q3JlZGl0UmVxdWVzdCk7CisJCWNyZWRpdHMuaW5zdGFuY2UgPSBzZXJ2ZXItPnJlY29ubmVjdF9p
bnN0YW5jZTsKKwkJcWRfaW8tPnJlc3VsdCA9IHNtYl9FSU8oc21iX2Vpb190cmFjZV9yZWFkX3Jz
cF9tYWxmb3JtZWQpOworCQlicmVhazsKKwlkZWZhdWx0OgorCQlxZF9pby0+cmVzdWx0ID0gc21i
X0VJTzEoc21iX2Vpb190cmFjZV9yZWFkX21pZF9zdGF0ZV91bmtub3duLAorCQkJCQkgbWlkLT5t
aWRfc3RhdGUpOworCQlicmVhazsKKwl9CisKKwlpZiAocWRfaW8tPnJlc3VsdCAmJiBxZF9pby0+
cmVzdWx0ICE9IC1FTk9EQVRBKQorCQljaWZzX3N0YXRzX2ZhaWxfaW5jKHRjb24sIFNNQjJfUVVF
UllfRElSRUNUT1JZX0hFKTsKKworCXRyYWNlX3NtYjNfcndfY3JlZGl0cygwLCAwLCBxZF9pby0+
Y3JlZGl0cy52YWx1ZSwKKwkJCSAgICAgIHNlcnZlci0+Y3JlZGl0cywgc2VydmVyLT5pbl9mbGln
aHQsCisJCQkgICAgICAwLCBjaWZzX3RyYWNlX3J3X2NyZWRpdHNfcmVhZF9yZXNwb25zZV9jbGVh
cik7CisJcWRfaW8tPmNyZWRpdHMudmFsdWUgPSAwOworCXJlbGVhc2VfbWlkKHNlcnZlciwgbWlk
KTsKKwl0cmFjZV9zbWIzX3J3X2NyZWRpdHMoMCwgMCwgMCwKKwkJCSAgICAgIHNlcnZlci0+Y3Jl
ZGl0cywgc2VydmVyLT5pbl9mbGlnaHQsCisJCQkgICAgICBjcmVkaXRzLnZhbHVlLCBjaWZzX3Ry
YWNlX3J3X2NyZWRpdHNfcmVhZF9yZXNwb25zZV9hZGQpOworCWFkZF9jcmVkaXRzKHNlcnZlciwg
JmNyZWRpdHMsIDApOworCisJY29tcGxldGUoJnFkX2lvLT5kb25lKTsKK30KKworLyoKKyAqIFF1
ZXJ5RGlyZWN0b3J5IHdpdGggbGFyZ2UgYnVmZmVyIGFuZCBtdWx0aS1jcmVkaXQgc3VwcG9ydC4K
KyAqIFVzZXMgYXN5bmMgaW5mcmFzdHJ1Y3R1cmUgYnV0IHdhaXRzIGZvciBjb21wbGV0aW9uIHN5
bmNocm9ub3VzbHkuCisgKi8KK2ludAorU01CMl9xdWVyeV9kaXJlY3RvcnlfbGFyZ2Uoc3RydWN0
IGNpZnNfcXVlcnlfZGlyX2lvICpxZF9pbywgdW5zaWduZWQgaW50IGJ1Zl9zaXplKQoreworCWlu
dCByYywgZmxhZ3MgPSAwOworCWNoYXIgKmJ1ZjsKKwlzdHJ1Y3Qgc21iMl9oZHIgKnNoZHI7CisJ
c3RydWN0IHNtYl9ycXN0IHJxc3QgPSB7IC5ycV9pb3YgPSAmcWRfaW8tPmlvdlswXSwKKwkJCQkg
LnJxX252ZWMgPSBTTUIyX1FVRVJZX0RJUkVDVE9SWV9JT1ZfU0laRSB9OworCXN0cnVjdCBUQ1Bf
U2VydmVyX0luZm8gKnNlcnZlciA9IHFkX2lvLT5zZXJ2ZXI7CisJc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiA9IHFkX2lvLT50Y29uOworCXVuc2lnbmVkIGludCB0b3RhbF9sZW47CisJaW50IGNyZWRp
dF9yZXF1ZXN0OworCisJY2lmc19kYmcoRllJLCAiJXM6IGJ1Zl9zaXplPSV1XG4iLCBfX2Z1bmNf
XywgYnVmX3NpemUpOworCisJLyogQ2FwIGJ1ZmZlciBzaXplIHRvIGF2b2lkIGttYWxsb2MgZmFp
bHVyZXMgZm9yIHZlcnkgbGFyZ2UgYWxsb2NhdGlvbnMuCisJICogU01CMl9NQVhfUURfREFUQUJV
Rl9TSVpFIGlzIGEgc2FmZSBsaW1pdCB0aGF0IHN0YXlzIHdlbGwgYmVsb3cgdHlwaWNhbAorCSAq
IGttYWxsb2MgY29uc3RyYWludHMgd2hpbGUgc3RpbGwgYWxsb3dpbmcgbGFyZ2UgZGlyZWN0b3J5
IGxpc3RpbmdzLgorCSAqLworCWlmIChidWZfc2l6ZSA+IFNNQjJfTUFYX1FEX0RBVEFCVUZfU0la
RSkKKwkJYnVmX3NpemUgPSBTTUIyX01BWF9RRF9EQVRBQlVGX1NJWkU7CisKKwkvKiBBbGxvY2F0
ZSByZXNwb25zZSBidWZmZXIuIFNpbmNlIHdlJ2xsIGJ1aWxkIGEgY29tYmluZWQgaGVhZGVyK2Rh
dGEgYnVmZmVyLAorCSAqIHdlIG5lZWQgc3BhY2UgZm9yIGJvdGguIFdlJ2xsIHJlcXVlc3QgYSBz
bGlnaHRseSBzbWFsbGVyIE91dHB1dEJ1ZmZlckxlbmd0aAorCSAqIGZyb20gdGhlIHNlcnZlciB0
byBlbnN1cmUgdGhlIHRvdGFsIHJlc3BvbnNlIGZpdHMuCisJICovCisJcWRfaW8tPmNvbWJpbmVk
X2lvdi5pb3ZfYmFzZSA9IGttYWxsb2MoYnVmX3NpemUsIEdGUF9LRVJORUwpOworCWlmICghcWRf
aW8tPmNvbWJpbmVkX2lvdi5pb3ZfYmFzZSkKKwkJcmV0dXJuIC1FTk9NRU07CisJLyogU3RvcmUg
dG90YWwgY2FwYWNpdHkgaW4gaW92X2xlbjsgdXBkYXRlZCB0byBhY3R1YWwgZGF0YSBsZW5ndGgg
YnkgcmVjZWl2ZSBoYW5kbGVyICovCisJcWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfbGVuID0gYnVm
X3NpemU7CisKKwkvKiBJbml0aWFsaXplIGNvbXBsZXRpb24gKi8KKwlpbml0X2NvbXBsZXRpb24o
JnFkX2lvLT5kb25lKTsKKworCS8qIFJlcXVlc3QgbGVzcyBkYXRhIGZyb20gc2VydmVyIHRvIGxl
YXZlIHJvb20gZm9yIHRoZSByZXNwb25zZSBoZWFkZXIuCisJICogVXNlIE1BWF9DSUZTX1NNQUxM
X0JVRkZFUl9TSVpFIGFzIGEgc2FmZXR5IG1hcmdpbi4KKwkgKi8KKwlyYyA9IFNNQjJfcXVlcnlf
ZGlyZWN0b3J5X2luaXQocWRfaW8tPnhpZCwgdGNvbiwgc2VydmVyLAorCQkJCSAgICAgICAmcnFz
dCwgcWRfaW8tPnBlcnNpc3RlbnRfZmlkLAorCQkJCSAgICAgICBxZF9pby0+dm9sYXRpbGVfZmlk
LCBxZF9pby0+aW5kZXgsCisJCQkJICAgICAgIHFkX2lvLT5zcmNoX2luZi0+aW5mb19sZXZlbCwK
KwkJCQkgICAgICAgYnVmX3NpemUgLSBNQVhfQ0lGU19TTUFMTF9CVUZGRVJfU0laRSk7CisJaWYg
KHJjKSB7CisJCWtmcmVlKHFkX2lvLT5jb21iaW5lZF9pb3YuaW92X2Jhc2UpOworCQlxZF9pby0+
Y29tYmluZWRfaW92Lmlvdl9iYXNlID0gTlVMTDsKKwkJcmV0dXJuIHJjOworCX0KKworCWlmIChz
bWIzX2VuY3J5cHRpb25fcmVxdWlyZWQodGNvbikpCisJCWZsYWdzIHw9IENJRlNfVFJBTlNGT1JN
X1JFUTsKKworCWJ1ZiA9IHJxc3QucnFfaW92WzBdLmlvdl9iYXNlOworCXRvdGFsX2xlbiA9IHJx
c3QucnFfaW92WzBdLmlvdl9sZW47CisKKwlzaGRyID0gKHN0cnVjdCBzbWIyX2hkciAqKWJ1ZjsK
KworCWlmIChxZF9pby0+cmVwbGF5KSB7CisJCS8qIEJhY2stb2ZmIGJlZm9yZSByZXRyeSAqLwor
CQlpZiAocWRfaW8tPmN1cl9zbGVlcCkKKwkJCW1zbGVlcChxZF9pby0+Y3VyX3NsZWVwKTsKKwkJ
c21iMl9zZXRfcmVwbGF5KHNlcnZlciwgJnJxc3QpOworCX0KKworCS8qIFNldCBjcmVkaXQgY2hh
cmdlIGJhc2VkIG9uIGJ1ZmZlciBzaXplICovCisJaWYgKHFkX2lvLT5jcmVkaXRzLnZhbHVlID4g
MCkgeworCQlzaGRyLT5DcmVkaXRDaGFyZ2UgPSBjcHVfdG9fbGUxNihESVZfUk9VTkRfVVAoYnVm
X3NpemUsCisJCQkJCQlTTUIyX01BWF9CVUZGRVJfU0laRSkpOworCQljcmVkaXRfcmVxdWVzdCA9
IGxlMTZfdG9fY3B1KHNoZHItPkNyZWRpdENoYXJnZSkgKyA4OworCQlpZiAoc2VydmVyLT5jcmVk
aXRzID49IHNlcnZlci0+bWF4X2NyZWRpdHMpCisJCQlzaGRyLT5DcmVkaXRSZXF1ZXN0ID0gY3B1
X3RvX2xlMTYoMCk7CisJCWVsc2UKKwkJCXNoZHItPkNyZWRpdFJlcXVlc3QgPSBjcHVfdG9fbGUx
NigKKwkJCQltaW5fdChpbnQsIHNlcnZlci0+bWF4X2NyZWRpdHMgLQorCQkJCQkJc2VydmVyLT5j
cmVkaXRzLCBjcmVkaXRfcmVxdWVzdCkpOworCisJCWZsYWdzIHw9IENJRlNfSEFTX0NSRURJVFM7
CisJfQorCisJcmMgPSBjaWZzX2NhbGxfYXN5bmMoc2VydmVyLCAmcnFzdCwKKwkJCSAgICAgY2lm
c19xdWVyeV9kaXJfcmVjZWl2ZSwgc21iMl9xdWVyeV9kaXJfY2FsbGJhY2ssCisJCQkgICAgIHNt
YjJfcXVlcnlfZGlyX2hhbmRsZV9kYXRhLCBxZF9pbywgZmxhZ3MsCisJCQkgICAgICZxZF9pby0+
Y3JlZGl0cyk7CisJaWYgKHJjKSB7CisJCWNpZnNfc3RhdHNfZmFpbF9pbmModGNvbiwgU01CMl9R
VUVSWV9ESVJFQ1RPUllfSEUpOworCQl0cmFjZV9zbWIzX3F1ZXJ5X2Rpcl9lcnIocWRfaW8tPnhp
ZCwgcWRfaW8tPnBlcnNpc3RlbnRfZmlkLAorCQkJCQkgdGNvbi0+dGlkLCB0Y29uLT5zZXMtPlN1
aWQsCisJCQkJCSBxZF9pby0+aW5kZXgsIDAsIHJjKTsKKwkJa2ZyZWUocWRfaW8tPmNvbWJpbmVk
X2lvdi5pb3ZfYmFzZSk7CisJCXFkX2lvLT5jb21iaW5lZF9pb3YuaW92X2Jhc2UgPSBOVUxMOwor
CX0KKworCS8qIEZyZWUgcmVxdWVzdCBidWZmZXIgaW1tZWRpYXRlbHkgYWZ0ZXIgYXN5bmMgY2Fs
bCAqLworCWNpZnNfc21hbGxfYnVmX3JlbGVhc2UoYnVmKTsKKworCWlmIChyYykKKwkJcmV0dXJu
IHJjOworCisJLyogV2FpdCBmb3IgdGhlIGFzeW5jIG9wZXJhdGlvbiB0byBjb21wbGV0ZSAqLwor
CXdhaXRfZm9yX2NvbXBsZXRpb24oJnFkX2lvLT5kb25lKTsKKwlyZXR1cm4gcWRfaW8tPnJlc3Vs
dDsKK30KKwogLyoKICAqIFJlYWRkaXIvRmluZEZpcnN0CiAgKi8KQEAgLTU1NzAsMTIgKzU3NDks
NiBAQCBpbnQgU01CMl9xdWVyeV9kaXJlY3RvcnlfaW5pdChjb25zdCB1bnNpZ25lZCBpbnQgeGlk
LAogCXJlcS0+RmlsZU5hbWVPZmZzZXQgPQogCQljcHVfdG9fbGUxNihzaXplb2Yoc3RydWN0IHNt
YjJfcXVlcnlfZGlyZWN0b3J5X3JlcSkpOwogCXJlcS0+RmlsZU5hbWVMZW5ndGggPSBjcHVfdG9f
bGUxNihsZW4pOwotCS8qCi0JICogQkIgY291bGQgYmUgMzAgYnl0ZXMgb3Igc28gbG9uZ2VyIGlm
IHdlIHVzZWQgU01CMiBzcGVjaWZpYwotCSAqIGJ1ZmZlciBsZW5ndGhzLCBidXQgdGhpcyBpcyBz
YWZlIGFuZCBjbG9zZSBlbm91Z2guCi0JICovCi0Jb3V0cHV0X3NpemUgPSBtaW5fdCh1bnNpZ25l
ZCBpbnQsIG91dHB1dF9zaXplLCBzZXJ2ZXItPm1heEJ1Zik7Ci0Jb3V0cHV0X3NpemUgPSBtaW5f
dCh1bnNpZ25lZCBpbnQsIG91dHB1dF9zaXplLCAyIDw8IDE1KTsKIAlyZXEtPk91dHB1dEJ1ZmZl
ckxlbmd0aCA9IGNwdV90b19sZTMyKG91dHB1dF9zaXplKTsKIAogCWlvdlswXS5pb3ZfYmFzZSA9
IChjaGFyICopcmVxOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmggYi9mcy9z
bWIvY2xpZW50L3NtYjJwZHUuaAppbmRleCA3YjdhODY0NTIwYzYuLjg0M2UzMGMxZWNjNiAxMDA2
NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmgKKysrIGIvZnMvc21iL2NsaWVudC9zbWIy
cGR1LmgKQEAgLTEzMiw2ICsxMzIsOSBAQCBzdHJ1Y3Qgc2hhcmVfcmVkaXJlY3RfZXJyb3JfY29u
dGV4dF9yc3AgewogLyogU2l6ZSBvZiB0aGUgbWluaW1hbCBRdWVyeURpciByZXNwb25zZSBmb3Ig
Y2hlY2tpbmcgaWYgbW9yZSBkYXRhIGV4aXN0cyAqLwogI2RlZmluZSBTTUIyX1FEMl9SRVNQT05T
RV9TSVpFIDQwOTYKIAorLyogbWF4IHF1ZXJ5IGRpcmVjdG9yeSBkYXRhIGJ1ZmZlciBzaXplICov
CisjZGVmaW5lIFNNQjJfTUFYX1FEX0RBVEFCVUZfU0laRSAoMiAqIDEwMjQgKiAxMDI0KQorCiAv
KgogICogT3V0cHV0IGJ1ZmZlciBzaXplIGZvciBmaXJzdCBRdWVyeURpciBpbiBDcmVhdGUrUUQx
K1FEMiBjb21wb3VuZC4KICAqIEFjY291bnRzIGZvciBzaGFyZWQgYnVmZmVyIHNwYWNlIG5lZWRl
ZCBmb3IgYWxsIHRocmVlIHJlc3BvbnNlcy4KZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21i
MnByb3RvLmggYi9mcy9zbWIvY2xpZW50L3NtYjJwcm90by5oCmluZGV4IDZiNGRjNGZlYTIxZS4u
YjI5OWUwOTdhYTUyIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwcm90by5oCisrKyBi
L2ZzL3NtYi9jbGllbnQvc21iMnByb3RvLmgKQEAgLTUxLDYgKzUxLDggQEAgX19sZTMyIHNtYjJf
Z2V0X2xlYXNlX3N0YXRlKHN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaW5vZGUsIHVuc2lnbmVkIGlu
dCBvcGxvY2spOwogYm9vbCBzbWIyX2lzX3ZhbGlkX29wbG9ja19icmVhayhjaGFyICpidWZmZXIs
IHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcik7CiBpbnQgc21iM19oYW5kbGVfcmVhZF9k
YXRhKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAkJCSAgc3RydWN0IG1pZF9xX2Vu
dHJ5ICptaWQpOworaW50IHNtYjJfcXVlcnlfZGlyX2hhbmRsZV9kYXRhKHN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8gKnNlcnZlciwKKwkJCSAgICAgICBzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCk7CiBz
dHJ1Y3QgaW5vZGUgKnNtYjJfY3JlYXRlX3JlcGFyc2VfaW5vZGUoc3RydWN0IGNpZnNfb3Blbl9p
bmZvX2RhdGEgKmRhdGEsCiAJCQkJCXN0cnVjdCBzdXBlcl9ibG9jayAqc2IsCiAJCQkJCWNvbnN0
IHVuc2lnbmVkIGludCB4aWQsCkBAIC0yMDIsNiArMjA0LDcgQEAgaW50IFNNQjJfcXVlcnlfZGly
ZWN0b3J5X2luaXQoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNv
biwKIAkJCSAgICAgIHU2NCB2b2xhdGlsZV9maWQsIGludCBpbmRleCwgaW50IGluZm9fbGV2ZWws
CiAJCQkgICAgICB1bnNpZ25lZCBpbnQgb3V0cHV0X3NpemUpOwogdm9pZCBTTUIyX3F1ZXJ5X2Rp
cmVjdG9yeV9mcmVlKHN0cnVjdCBzbWJfcnFzdCAqcnFzdCk7CitpbnQgU01CMl9xdWVyeV9kaXJl
Y3RvcnlfbGFyZ2Uoc3RydWN0IGNpZnNfcXVlcnlfZGlyX2lvICpxZF9pbywgdW5zaWduZWQgaW50
IGJ1Zl9zaXplKTsKIGludCBTTUIyX3NldF9lb2YoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJIHU2NCBwZXJzaXN0ZW50X2ZpZCwgdTY0IHZvbGF0aWxl
X2ZpZCwgdTMyIHBpZCwKIAkJIGxvZmZfdCBuZXdfZW9mKTsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9j
bGllbnQvdHJhY2UuaCBiL2ZzL3NtYi9jbGllbnQvdHJhY2UuaAppbmRleCBiOTllYzVhNDE3ZmEu
LjllMTIwZDZmZTUxYyAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC90cmFjZS5oCisrKyBiL2Zz
L3NtYi9jbGllbnQvdHJhY2UuaApAQCAtMTY1LDYgKzE2NSw3IEBACiAJRU0oY2lmc190cmFjZV9y
d19jcmVkaXRzX3dyaXRlX3ByZXBhcmUsCQkid3ItcHJlcGFyZSAiKSBcCiAJRU0oY2lmc190cmFj
ZV9yd19jcmVkaXRzX3dyaXRlX3Jlc3BvbnNlX2FkZCwJIndyLXJlc3AtYWRkIikgXAogCUVNKGNp
ZnNfdHJhY2VfcndfY3JlZGl0c193cml0ZV9yZXNwb25zZV9jbGVhciwJIndyLXJlc3AtY2xyIikg
XAorCUVNKGNpZnNfdHJhY2VfcndfY3JlZGl0c19xdWVyeV9kaXJfZG9uZSwJInFkLWRvbmUgICAg
IikgXAogCUVfKGNpZnNfdHJhY2VfcndfY3JlZGl0c196ZXJvX2luX2ZsaWdodCwJIlpFUk8tSU4t
RkxUIikKIAogI2RlZmluZSBzbWIzX3Rjb25fcmVmX3RyYWNlcwkJCQkJICAgICAgXApkaWZmIC0t
Z2l0IGEvZnMvc21iL2NsaWVudC90cmFuc3BvcnQuYyBiL2ZzL3NtYi9jbGllbnQvdHJhbnNwb3J0
LmMKaW5kZXggMDVmODA5OTA0N2UxLi42YTU1Y2ExNGFmMjUgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9j
bGllbnQvdHJhbnNwb3J0LmMKKysrIGIvZnMvc21iL2NsaWVudC90cmFuc3BvcnQuYwpAQCAtMTE1
NCw2ICsxMTU0LDE3NiBAQCBjaWZzX3JlYWR2X2Rpc2NhcmQoc3RydWN0IFRDUF9TZXJ2ZXJfSW5m
byAqc2VydmVyLCBzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCkKIAlyZXR1cm4gIF9fY2lmc19yZWFk
dl9kaXNjYXJkKHNlcnZlciwgbWlkLCByZGF0YS0+cmVzdWx0KTsKIH0KIAorc3RhdGljIGludAor
Y2lmc19xdWVyeV9kaXJfZGlzY2FyZChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHN0
cnVjdCBtaWRfcV9lbnRyeSAqbWlkLAorCQkgICAgICBib29sIG1hbGZvcm1lZCkKK3sKKwlpbnQg
bGVuZ3RoOworCisJbGVuZ3RoID0gY2lmc19kaXNjYXJkX3JlbWFpbmluZ19kYXRhKHNlcnZlcik7
CisJZGVxdWV1ZV9taWQoc2VydmVyLCBtaWQsIG1hbGZvcm1lZCk7CisJbWlkLT5yZXNwX2J1ZiA9
IHNlcnZlci0+c21hbGxidWY7CisJc2VydmVyLT5zbWFsbGJ1ZiA9IE5VTEw7CisJcmV0dXJuIGxl
bmd0aDsKK30KKworLyoKKyAqIFJlY2VpdmUgaGFuZGxlciBmb3IgYXN5bmMgUXVlcnlEaXJlY3Rv
cnkgd2l0aCBtdWx0aS1jcmVkaXQgc3VwcG9ydAorICovCitpbnQKK2NpZnNfcXVlcnlfZGlyX3Jl
Y2VpdmUoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3QgbWlkX3FfZW50cnkg
Km1pZCkKK3sKKwlpbnQgbGVuZ3RoLCBsZW47CisJdW5zaWduZWQgaW50IGRhdGFfb2Zmc2V0LCBk
YXRhX2xlbiwgcmVzcF9zaXplOworCXN0cnVjdCBjaWZzX3F1ZXJ5X2Rpcl9pbyAqcWRfaW8gPSBt
aWQtPmNhbGxiYWNrX2RhdGE7CisJY2hhciAqYnVmID0gc2VydmVyLT5zbWFsbGJ1ZjsKKwl1bnNp
Z25lZCBpbnQgYnVmbGVuID0gc2VydmVyLT5wZHVfc2l6ZTsKKwlzdHJ1Y3Qgc21iMl9xdWVyeV9k
aXJlY3RvcnlfcnNwICpyc3A7CisKKwljaWZzX2RiZyhGWUksICIlczogbWlkPSVsbHUgYnVmX2Nh
cGFjaXR5PSV6dVxuIiwKKwkJIF9fZnVuY19fLCBtaWQtPm1pZCwgcWRfaW8tPmNvbWJpbmVkX2lv
di5pb3ZfbGVuKTsKKworCS8qCisJICogUmVhZCB0aGUgcmVzdCBvZiBRVUVSWV9ESVJFQ1RPUllf
UlNQIGhlYWRlciAoc2FucyBEYXRhIGFycmF5KS4KKwkgKiBRdWVyeURpcmVjdG9yeSByZXNwb25z
ZSBzdHJ1Y3R1cmUgaXMgNjQgYnl0ZXMgKFNNQjIgaGVhZGVyKSArIDggYnl0ZXMgKGZpeGVkIHBh
cnQpLgorCSAqLworCXJlc3Bfc2l6ZSA9IHNpemVvZihzdHJ1Y3Qgc21iMl9xdWVyeV9kaXJlY3Rv
cnlfcnNwKTsKKwlsZW4gPSBtaW5fdCh1bnNpZ25lZCBpbnQsIGJ1ZmxlbiwgcmVzcF9zaXplKSAt
IEhFQURFUl9TSVpFKHNlcnZlcikgKyAxOworCisJbGVuZ3RoID0gY2lmc19yZWFkX2Zyb21fc29j
a2V0KHNlcnZlciwKKwkJCQkgICAgICAgYnVmICsgSEVBREVSX1NJWkUoc2VydmVyKSAtIDEsIGxl
bik7CisJaWYgKGxlbmd0aCA8IDApIHsKKwkJcWRfaW8tPnJlc3VsdCA9IGxlbmd0aDsKKwkJcmV0
dXJuIGNpZnNfcXVlcnlfZGlyX2Rpc2NhcmQoc2VydmVyLCBtaWQsIGZhbHNlKTsKKwl9CisJc2Vy
dmVyLT50b3RhbF9yZWFkICs9IGxlbmd0aDsKKworCWlmIChzZXJ2ZXItPm9wcy0+aXNfc2Vzc2lv
bl9leHBpcmVkICYmCisJICAgIHNlcnZlci0+b3BzLT5pc19zZXNzaW9uX2V4cGlyZWQoYnVmKSkg
eworCQljaWZzX3JlY29ubmVjdChzZXJ2ZXIsIHRydWUpOworCQlyZXR1cm4gLTE7CisJfQorCisJ
aWYgKHNlcnZlci0+b3BzLT5pc19zdGF0dXNfcGVuZGluZyAmJgorCSAgICBzZXJ2ZXItPm9wcy0+
aXNfc3RhdHVzX3BlbmRpbmcoYnVmLCBzZXJ2ZXIpKSB7CisJCWNpZnNfZGlzY2FyZF9yZW1haW5p
bmdfZGF0YShzZXJ2ZXIpOworCQlyZXR1cm4gLTE7CisJfQorCisJLyogSXMgdGhlcmUgZW5vdWdo
IHRvIGdldCB0byB0aGUgcmVzdCBvZiB0aGUgUVVFUllfRElSRUNUT1JZX1JTUCBoZWFkZXI/ICov
CisJaWYgKHNlcnZlci0+dG90YWxfcmVhZCA8IHJlc3Bfc2l6ZSkgeworCQljaWZzX2RiZyhGWUks
ICIlczogc2VydmVyIHJldHVybmVkIHNob3J0IGhlYWRlci4gZ290PSV1IGV4cGVjdGVkPSV1XG4i
LAorCQkJIF9fZnVuY19fLCBzZXJ2ZXItPnRvdGFsX3JlYWQsIHJlc3Bfc2l6ZSk7CisJCXFkX2lv
LT5yZXN1bHQgPSBzbWJfRUlPMihzbWJfZWlvX3RyYWNlX3JlYWRfcnNwX3Nob3J0LAorCQkJCQkg
c2VydmVyLT50b3RhbF9yZWFkLCByZXNwX3NpemUpOworCQlyZXR1cm4gY2lmc19xdWVyeV9kaXJf
ZGlzY2FyZChzZXJ2ZXIsIG1pZCwgdHJ1ZSk7CisJfQorCisJLyogU2V0IHVwIGZpcnN0IGlvdiBm
b3Igc2lnbmF0dXJlIGNoZWNrIGFuZCB0byBnZXQgY3JlZGl0cyAqLworCXFkX2lvLT5pb3ZbMF0u
aW92X2Jhc2UgPSBidWY7CisJcWRfaW8tPmlvdlswXS5pb3ZfbGVuID0gc2VydmVyLT50b3RhbF9y
ZWFkOworCXFkX2lvLT5pb3ZbMV0uaW92X2Jhc2UgPSBOVUxMOworCXFkX2lvLT5pb3ZbMV0uaW92
X2xlbiA9IDA7CisJY2lmc19kYmcoRllJLCAiMDogaW92X2Jhc2U9JXAgaW92X2xlbj0lenVcbiIs
CisJCSBxZF9pby0+aW92WzBdLmlvdl9iYXNlLCBxZF9pby0+aW92WzBdLmlvdl9sZW4pOworCisJ
LyogUGFyc2UgaGVhZGVyIGVhcmx5IHRvIGFjY2VzcyBzdGF0dXMgYmVmb3JlIG1hcF9lcnJvciBj
b252ZXJ0cyBpdCAqLworCXJzcCA9IChzdHJ1Y3Qgc21iMl9xdWVyeV9kaXJlY3RvcnlfcnNwICop
YnVmOworCisJLyogV2FzIHRoZSBTTUIgcXVlcnlfZGlyZWN0b3J5IHN1Y2Nlc3NmdWw/ICovCisJ
cWRfaW8tPnJlc3VsdCA9IHNlcnZlci0+b3BzLT5tYXBfZXJyb3IoYnVmLCBmYWxzZSk7CisJaWYg
KHFkX2lvLT5yZXN1bHQgIT0gMCkgeworCQlpZiAocWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfYmFz
ZSAmJiBxZF9pby0+aW92WzBdLmlvdl9sZW4gPiAwICYmCisJCSAgICBxZF9pby0+aW92WzBdLmlv
dl9sZW4gPD0gcWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfbGVuKSB7CisJCQltZW1jcHkocWRfaW8t
PmNvbWJpbmVkX2lvdi5pb3ZfYmFzZSwgcWRfaW8tPmlvdlswXS5pb3ZfYmFzZSwKKwkJCSAgICAg
ICBxZF9pby0+aW92WzBdLmlvdl9sZW4pOworCQkJcWRfaW8tPmlvdlswXS5pb3ZfYmFzZSA9IHFk
X2lvLT5jb21iaW5lZF9pb3YuaW92X2Jhc2U7CisJCX0KKwkJY2lmc19kYmcoRllJLCAiJXM6IHNl
cnZlciByZXR1cm5lZCBlcnJvciAlZCAoU3RhdHVzIHdhcyAweCV4KVxuIiwKKwkJCSBfX2Z1bmNf
XywgcWRfaW8tPnJlc3VsdCwgbGUzMl90b19jcHUocnNwLT5oZHIuU3RhdHVzKSk7CisJCXJldHVy
biBjaWZzX3F1ZXJ5X2Rpcl9kaXNjYXJkKHNlcnZlciwgbWlkLCBmYWxzZSk7CisJfQorCisJZGF0
YV9vZmZzZXQgPSBsZTE2X3RvX2NwdShyc3AtPk91dHB1dEJ1ZmZlck9mZnNldCk7CisJZGF0YV9s
ZW4gPSBsZTMyX3RvX2NwdShyc3AtPk91dHB1dEJ1ZmZlckxlbmd0aCk7CisKKwljaWZzX2RiZyhG
WUksICIlczogdG90YWxfcmVhZD0ldSBkYXRhX29mZnNldD0ldSBkYXRhX2xlbj0ldVxuIiwKKwkJ
IF9fZnVuY19fLCBzZXJ2ZXItPnRvdGFsX3JlYWQsIGRhdGFfb2Zmc2V0LCBkYXRhX2xlbik7CisK
KwkvKiBWYWxpZGF0ZSBkYXRhX29mZnNldCBhbmQgZGF0YV9sZW4gKi8KKwlpZiAoZGF0YV9vZmZz
ZXQgPCBzZXJ2ZXItPnRvdGFsX3JlYWQpIHsKKwkJY2lmc19kYmcoRllJLCAiJXM6IGRhdGEgb2Zm
c2V0ICgldSkgaW5zaWRlIHJlc3BvbnNlIGhlYWRlclxuIiwKKwkJCSBfX2Z1bmNfXywgZGF0YV9v
ZmZzZXQpOworCQlkYXRhX29mZnNldCA9IHNlcnZlci0+dG90YWxfcmVhZDsKKwkJZGF0YV9sZW4g
PSAwOworCX0gZWxzZSBpZiAoZGF0YV9vZmZzZXQgPiBNQVhfQ0lGU19TTUFMTF9CVUZGRVJfU0la
RSkgeworCQljaWZzX2RiZyhGWUksICIlczogZGF0YSBvZmZzZXQgKCV1KSBiZXlvbmQgZW5kIG9m
IHNtYWxsYnVmXG4iLAorCQkJIF9fZnVuY19fLCBkYXRhX29mZnNldCk7CisJCXFkX2lvLT5yZXN1
bHQgPSBzbWJfRUlPMShzbWJfZWlvX3RyYWNlX3JlYWRfb3ZlcmxhcmdlLAorCQkJCQkgZGF0YV9v
ZmZzZXQpOworCQlyZXR1cm4gY2lmc19xdWVyeV9kaXJfZGlzY2FyZChzZXJ2ZXIsIG1pZCwgdHJ1
ZSk7CisJfQorCisJLyogUmVhZCBhbnkgcGFkZGluZyBiZXR3ZWVuIGhlYWRlciBhbmQgZGF0YSAq
LworCWxlbiA9IGRhdGFfb2Zmc2V0IC0gc2VydmVyLT50b3RhbF9yZWFkOworCWlmIChsZW4gPiAw
KSB7CisJCWxlbmd0aCA9IGNpZnNfcmVhZF9mcm9tX3NvY2tldChzZXJ2ZXIsCisJCQkJCSAgICAg
ICBidWYgKyBzZXJ2ZXItPnRvdGFsX3JlYWQsIGxlbik7CisJCWlmIChsZW5ndGggPCAwKSB7CisJ
CQlxZF9pby0+cmVzdWx0ID0gbGVuZ3RoOworCQkJcmV0dXJuIGNpZnNfcXVlcnlfZGlyX2Rpc2Nh
cmQoc2VydmVyLCBtaWQsIGZhbHNlKTsKKwkJfQorCQlzZXJ2ZXItPnRvdGFsX3JlYWQgKz0gbGVu
Z3RoOworCQlxZF9pby0+aW92WzBdLmlvdl9sZW4gPSBzZXJ2ZXItPnRvdGFsX3JlYWQ7CisJfQor
CisJLyogQ2hlY2sgaWYgZGF0YSBmaXRzIGluIHRoZSBwcmUtYWxsb2NhdGVkIGNvbWJpbmVkIGJ1
ZmZlciAqLworCWlmIChxZF9pby0+aW92WzBdLmlvdl9sZW4gKyBkYXRhX2xlbiA+IHFkX2lvLT5j
b21iaW5lZF9pb3YuaW92X2xlbikgeworCQljaWZzX2RiZyhWRlMsICIlczogcmVzcG9uc2UgKCV6
dSArICV1KSBleGNlZWRzIGJ1ZmZlciBjYXBhY2l0eSAoJXp1KVxuIiwKKwkJCSBfX2Z1bmNfXywg
cWRfaW8tPmlvdlswXS5pb3ZfbGVuLCBkYXRhX2xlbiwgcWRfaW8tPmNvbWJpbmVkX2lvdi5pb3Zf
bGVuKTsKKwkJcWRfaW8tPnJlc3VsdCA9IHNtYl9FSU8yKHNtYl9laW9fdHJhY2VfcmVhZF9yc3Bf
bWFsZm9ybWVkLAorCQkJCQkgZGF0YV9sZW4sICh1bnNpZ25lZCBpbnQpcWRfaW8tPmNvbWJpbmVk
X2lvdi5pb3ZfbGVuKTsKKwkJcmV0dXJuIGNpZnNfcXVlcnlfZGlyX2Rpc2NhcmQoc2VydmVyLCBt
aWQsIHRydWUpOworCX0KKworCS8qCisJICogQnVpbGQgY29tYmluZWQgaGVhZGVyK2RhdGEgaW4g
cWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfYmFzZSwKKwkgKiBwcmVzZXJ2aW5nIHRoZSB3aXJlIGxh
eW91dCBzbyBTTUIyIHNpZ25pbmcgY2FuIGJlIHZlcmlmaWVkIGFnYWluc3QKKwkgKiB0aGUgZXhh
Y3Qgb24tdGhlLXdpcmUgYnl0ZXMuICBoZHJfbGVuIGFscmVhZHkgYWNjb3VudHMgZm9yIHRoZQor
CSAqIGhlYWRlciBhbmQgYW55IHBhZGRpbmcgdXAgdG8gZGF0YV9vZmZzZXQ7IGRhdGEgaXMgcmVh
ZCBhdCB0aGF0CisJICogc2FtZSBvZmZzZXQuICBPdXRwdXRCdWZmZXJPZmZzZXQvTGVuZ3RoIGFy
ZSBsZWZ0IHVudG91Y2hlZC4KKwkgKi8KKwlpZiAocWRfaW8tPmlvdlswXS5pb3ZfbGVuID4gMCAm
JiBxZF9pby0+cmVzdWx0ID09IDApIHsKKwkJc2l6ZV90IGhkcl9sZW4gPSBxZF9pby0+aW92WzBd
Lmlvdl9sZW47CisKKwkJLyogQ29weSBoZWFkZXIrcGFkZGluZyB0byBjb21iaW5lZCBidWZmZXIs
IHByZXNlcnZpbmcgd2lyZSBsYXlvdXQgKi8KKwkJbWVtY3B5KHFkX2lvLT5jb21iaW5lZF9pb3Yu
aW92X2Jhc2UsIHFkX2lvLT5pb3ZbMF0uaW92X2Jhc2UsIGhkcl9sZW4pOworCisJCS8qIFJlYWQg
ZGlyZWN0b3J5IGVudHJpZXMgYXQgdGhlIHdpcmUgZGF0YV9vZmZzZXQgcG9zaXRpb24gKi8KKwkJ
aWYgKGRhdGFfbGVuID4gMCkgeworCQkJbGVuZ3RoID0gY2lmc19yZWFkX2Zyb21fc29ja2V0KHNl
cnZlciwKKwkJCQkJCSAgICAgICBxZF9pby0+Y29tYmluZWRfaW92Lmlvdl9iYXNlICsgaGRyX2xl
biwKKwkJCQkJCSAgICAgICBkYXRhX2xlbik7CisJCQlpZiAobGVuZ3RoIDwgMCkgeworCQkJCXFk
X2lvLT5yZXN1bHQgPSBsZW5ndGg7CisJCQkJcmV0dXJuIGNpZnNfcXVlcnlfZGlyX2Rpc2NhcmQo
c2VydmVyLCBtaWQsIGZhbHNlKTsKKwkJCX0KKwkJCXNlcnZlci0+dG90YWxfcmVhZCArPSBsZW5n
dGg7CisKKwkJCS8qIFNldCB1cCBzZWNvbmQgaW92IHBvaW50aW5nIHRvIGRpcmVjdG9yeSBkYXRh
IHdpdGhpbiBjb21iaW5lZCBidWZmZXIgKi8KKwkJCXFkX2lvLT5pb3ZbMV0uaW92X2Jhc2UgPSBx
ZF9pby0+Y29tYmluZWRfaW92Lmlvdl9iYXNlICsgaGRyX2xlbjsKKwkJCXFkX2lvLT5pb3ZbMV0u
aW92X2xlbiA9IGxlbmd0aDsKKwkJfQorCisJCXFkX2lvLT5jb21iaW5lZF9pb3YuaW92X2xlbiA9
IGhkcl9sZW4gKyAoZGF0YV9sZW4gPiAwID8gbGVuZ3RoIDogMCk7CisKKwkJY2lmc19kYmcoRllJ
LCAidG90YWxfcmVhZD0ldSBidWZsZW49JXUgZGF0YV9sZW49JXUgaGRyX2xlbj0lenUgY29tYmlu
ZWRfbGVuPSV6dVxuIiwKKwkJCXNlcnZlci0+dG90YWxfcmVhZCwgYnVmbGVuLCBkYXRhX2xlbiwg
aGRyX2xlbiwgcWRfaW8tPmNvbWJpbmVkX2lvdi5pb3ZfbGVuKTsKKwl9CisKKwlyZXR1cm4gY2lm
c19xdWVyeV9kaXJfZGlzY2FyZChzZXJ2ZXIsIG1pZCwgZmFsc2UpOworfQorCiBpbnQKIGNpZnNf
cmVhZHZfcmVjZWl2ZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHN0cnVjdCBtaWRf
cV9lbnRyeSAqbWlkKQogewotLSAKMi41MS4wCgo=
--000000000000f96a990651964a16--
