Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570E386C17
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 22:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778798370; cv=pass; b=R1JglETktqiBgNgP1bXP0MRHA2x64o4d/fFFmn7dgc+F6U6EUx8T7J0mZelW3j5ivt4WtXyO4JHKIDIv4qfJfKBGPpTsgyImfgdEMy1PMNqmec1HJwdEbU4sbTW1m1fVSIPIIHjvlKbpaRvI7qezU9ngp9MOI1HBw2xlFwn8wt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778798370; c=relaxed/simple;
	bh=RoJCssy3ZEQxs9jgyk5Sm1Bi9zJgYAOqOdgQckXlS0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tW1Qd3qZ4/xoAqvSSYKUBhWbkkYawC1ThoGTkOJ+pfIilnwr57WfmxJnAISPXfisfJeJxTB7Y/U8VbTxDO9KLxTXAc60DWa/c6xrObQG6zQ6tap2+o8KSRQwHGou3EHxOxBjt37HX3Qeled90z9qDlnZIa2lTMLaUFs3rXToX5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p8EBe04a; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p8EBe04a"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-90eb7a63a30so237163385a.2
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 15:39:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778798366; cv=none;
        d=google.com; s=arc-20240605;
        b=PcwfQi+DmAoAzivT1jy8qGW40zN6HPMT90W8/EZ1z8ZnLUBil9lCc9Kzca+NHaBzqQ
         R+2pFoDzQCWcuOJAW1h2Rm3XZVYW+ot2fOGFZ4KjkqC5aNQr3gRNt2vZXJSitvj2xW6m
         IL1KmMJIjqm9NndkL2WOUhe3jSLVdNVCn+fESUqR1cbitkUYvFXZYo/dANPrHqR4ilti
         CueGHaWhs279IVmfLb0aiAxyCc5rs9alx2N11P6mjwr9NyISqMeyHcPwVsuSjf2kQBbR
         6wrHucBbdRRCI3D10sFCIfjdqKQMTu5oltBrb4f6UUFg+wZStuXDODZ351gZE4vH4hfu
         63Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lmt3pY9thqz55XgHEIMSoZJypPxpr50B3mJLdZ8rUgE=;
        fh=7A3r6+09tzNnhHTw+uNnYVJyzJRQqAQTAUc0TDW5sqE=;
        b=XpCdRdsUYQFbGuIR/CxXmnaxEruXUEdjrU8NHtr8o7ztWzdoeiCLXdy6iVkwsqjuOd
         uyO7bI/vrTsH/I20rDoIHOi18HryRUKENok7/mu3QAf/f3cQCPkg2L6y9ynXpAftDEnX
         pHEnaPsdevPcXaI1xbMAz9mNd0qNghHgmqx9MxYmIh8FcKKYWxF3FQcZ3LKOiM5eXytH
         fqsbdaoyzLUGrGkyfcuBWt6MppPq96HEEYI0gkybQw3ipkE0tzeY58RN4GiPZ75m1GHd
         HLqTCB9gs2oastR8sNo3G7Xsd2a1OtMdV1x7m/APo2Nt+7D3zpge6nNH2SaSg/Ng+pGx
         UEcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778798366; x=1779403166; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmt3pY9thqz55XgHEIMSoZJypPxpr50B3mJLdZ8rUgE=;
        b=p8EBe04a55VCItjr/mVKScUeSLtl9fSAeWAQC4EU+BBJpsiF8TqvyQIbdfcmHY99y1
         dV68RTanfE1j9EE2RZTfJee8Tu56a55iC4JhdYLxpbIVuHl97fHLN+yMps8q/2eji/eJ
         qTXSDua95FLvOSw+w3YmQB1mbW16hddn6O931F6IQMLyAB9273d1yyTgah8ofhLuaKRy
         Qywp8I86N1Wsrzdf6J0l6nWL47YZiKpbCKzJLeQWjFMlDfiCUzbe7rhSvBx1ACX3tMR2
         jpzIhLaQpeGUQG9R4ULb/JnQzvtuIHA1eUd2tgeq0Hm7tZ9DMDU0rwwjtQjnwpcIgufu
         24jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778798366; x=1779403166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lmt3pY9thqz55XgHEIMSoZJypPxpr50B3mJLdZ8rUgE=;
        b=lvD2YbPTOG2cDVA8V4sLkPQCSK8GtB3oxahpmXtaQCM/qGAChZbLiR15XOHr0NBlTF
         7TKgPOJUlminUgT7Bjo624sJL/u/Gg8Ndxn4gA/XPrQ9V2gi5kQ9nI3K9BgQcQ+O3JfA
         OQkI4xJLJx5VJe69dP6PQV5CK9MWw6b5VuTngSr+Y5SZI/Nb7mGMuYFxBy1+dBrZM4/q
         LD/J14k1kg3HKVkq59lI5nsAnCkYy93HSTCdaBu4ZX0zYaWAbQxVwlZjd3kdc8QoDAsi
         G6gbgHy4GbBA1iRFePGIC8S95wljdoU8qPz8x8ii2KWwQk78XR2h8pJuze9qjkmYyTVz
         KYgw==
X-Gm-Message-State: AOJu0Yyts+3kRPrFF07R8f+0mDt67ToU1QykGGS9BUouY7BnuwtEkOd2
	y4n2d5D8sOucc2XQU4pRTDU78xkm/oXMr39chfrQz07msJRUu2jS6MZjLfOTfrouMlOs1o1Tm+Y
	uBUm7IBUudT6uKzEmsO7W66+6ZzPDZSU=
X-Gm-Gg: Acq92OEPotm8cqnngNz4OcHww8Dxt/S6qMPSnNy/FEUHlvl4mudGHY7sIhByYi3Aj6a
	BXMvqzC3JlcccnUkgnoJbQlyb50J6Ys1LNPp+00wr2IAxLBZFaeKM+55KEG4u917yk1+Go9EaZr
	sh8DvLGqcwITGhhu0x94QnAMT2fVI044G6z31b+EOA5xHHK5Vn7bs8yrhbdrGKWQmqvIguWG0YL
	P1RwX4Iauxc7DxUBeIBi3ZJpNVazB6PdC7m/iDSUYeCiv9NTS5Ba0USvKLNTRUJ7KbTbtScF+zp
	VBVQjkUdKVAOfl2WGxjju/UC51RpT3ubikddVPqtoQ2WslAl5gEBErz1Vn5X7QB6FWJohkFaQtT
	B6cL5vcAnVv3WkIE1jRBgiMs2/tB7HcKOY7oje0XU5PMrXqrn5tkfJIbTv0AoMxg+tCE4Nv04uF
	kSDlI7E3zLFmys8AEZdFH/KivFH0FBXx4=
X-Received: by 2002:a0c:d792:0:b0:8ca:7f:89b8 with SMTP id 6a1803df08f44-8ca0f5b12a2mr21411076d6.8.1778798365818;
 Thu, 14 May 2026 15:39:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514180823.497293-1-sprasad@microsoft.com> <20260514180823.497293-4-sprasad@microsoft.com>
In-Reply-To: <20260514180823.497293-4-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 14 May 2026 17:39:12 -0500
X-Gm-Features: AVHnY4JjeWv-LflC9eVEeKFCXGC8PIIEpetmSxlXyhfQ-HMGSpU67XtLgYVN87c
Message-ID: <CAH2r5mts4d5AOs04tp6e1Hv-8MBhoA4tPON95O6Dyx50Ppar4g@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] cifs: optimize readdir for larger directories
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This fixes the problem with the failure to ksmbd, but the large buffer
query dir requests are only being sent with 64K output buffer lengths,
instead of 1MB (to ksmbd) and potentially larger to Samba (although
1MB would probably be fine to Samba as well, although it allows up to
8MB).   So this patch would not help perf as much as the earlier
version

On Thu, May 14, 2026 at 1:08=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today QueryDirectory uses the compound_send_recv infrastructure
> which is limited to 16KB in size. As a result, readdir of large
> directories generally take several round trips.
>
> With this change, if the readdir needs a QueryDir after the first
> round-trip (meaning that there are more dirents to read), then the
> following QueryDirs will now switch to using larger buffers with
> MTU credits.
>
> Till now, the only command type that used this flow was SMB2_READ.
> In case of encrypted response, it becomes challenging to decide if
> the response is for SMB2_READ or SMB2_READDIR. This change reuses
> receive_encrypted_read and after decrypting the response decides
> the handling function based on the command in the resp header. That
> way, care has been taken to ensure that the read code path
> modifications on account of this change are kept to a minimum.
>
> The change also renames the discard function since both read and
> query_dir paths will now reuse the same function to discard remaining
> data in the socket and dequeue the mid.
>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h  |  21 +-
>  fs/smb/client/cifsproto.h |   3 +
>  fs/smb/client/readdir.c   |   2 +-
>  fs/smb/client/smb1ops.c   |   4 +-
>  fs/smb/client/smb2misc.c  |   7 +-
>  fs/smb/client/smb2ops.c   | 478 +++++++++++++++++++++++++++++++++++---
>  fs/smb/client/smb2pdu.c   | 185 ++++++++++++++-
>  fs/smb/client/smb2pdu.h   |   3 +
>  fs/smb/client/smb2proto.h |   3 +
>  fs/smb/client/trace.h     |   1 +
>  fs/smb/client/transport.c | 170 +++++++++++++-
>  11 files changed, 823 insertions(+), 54 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 79876c062d1d8..c895ef7fda2b7 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -501,7 +501,7 @@ struct smb_version_operations {
>                                struct cifs_search_info *);
>         /* continue readdir */
>         int (*query_dir_next)(const unsigned int, struct cifs_tcon *,
> -                             struct cifs_fid *,
> +                             struct cifs_sb_info *, struct cifs_fid *,
>                               __u16, struct cifs_search_info *srch_inf);
>         /* close dir */
>         int (*close_dir)(const unsigned int, struct cifs_tcon *,
> @@ -1394,6 +1394,25 @@ struct cifs_search_info {
>         bool is_dynamic_buf:1; /* dynamically allocated buffer - can be v=
ariable size */
>  };
>
> +/* Structure for QueryDirectory with multi-credit support */
> +struct cifs_query_dir_io {
> +       struct cifs_tcon *tcon;
> +       struct TCP_Server_Info *server;
> +       struct cifs_search_info *srch_inf;
> +       unsigned int xid;
> +       u64 persistent_fid;
> +       u64 volatile_fid;
> +       int index;
> +       struct kvec combined_iov;       /* Pre-allocated buffer to hold r=
esp */
> +       struct completion done;
> +       int result;
> +       struct cifs_credits credits;
> +       bool replay;
> +       unsigned int retries;
> +       unsigned int cur_sleep;
> +       struct kvec iov[2];             /* For response handling */
> +};
> +
>  #define ACL_NO_MODE    ((umode_t)(-1))
>  struct cifs_open_parms {
>         struct cifs_tcon *tcon;
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 79d891f7df1a5..25655c42e1dbc 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -336,6 +336,9 @@ struct cifs_ses *cifs_get_smb_ses(struct TCP_Server_I=
nfo *server,
>  int cifs_readv_receive(struct TCP_Server_Info *server,
>                        struct mid_q_entry *mid);
>
> +int cifs_query_dir_receive(struct TCP_Server_Info *server,
> +                           struct mid_q_entry *mid);
> +
>  int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>                           struct cifs_sb_info *cifs_sb,
>                           const unsigned char *path, char *pbuf,
> diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> index b50efd9b9e1d2..8a444f97e0ae9 100644
> --- a/fs/smb/client/readdir.c
> +++ b/fs/smb/client/readdir.c
> @@ -760,7 +760,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_t=
con *tcon, loff_t pos,
>         while ((index_to_find >=3D cfile->srch_inf.index_of_last_entry) &=
&
>                (rc =3D=3D 0) && !cfile->srch_inf.endOfSearch) {
>                 cifs_dbg(FYI, "calling findnext2\n");
> -               rc =3D server->ops->query_dir_next(xid, tcon, &cfile->fid=
,
> +               rc =3D server->ops->query_dir_next(xid, tcon, cifs_sb, &c=
file->fid,
>                                                  search_flags,
>                                                  &cfile->srch_inf);
>                 if (rc)
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index e198e3dda9177..6b0874fac2945 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -1132,8 +1132,8 @@ cifs_query_dir_first(const unsigned int xid, struct=
 cifs_tcon *tcon,
>
>  static int
>  cifs_query_dir_next(const unsigned int xid, struct cifs_tcon *tcon,
> -                   struct cifs_fid *fid, __u16 search_flags,
> -                   struct cifs_search_info *srch_inf)
> +                   struct cifs_sb_info *cifs_sb, struct cifs_fid *fid,
> +                   __u16 search_flags, struct cifs_search_info *srch_inf=
)
>  {
>         return CIFSFindNext(xid, tcon, fid->netfid, search_flags, srch_in=
f);
>  }
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index 2a7355ce1a078..c7a1fd7d5c955 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -12,6 +12,7 @@
>  #include "cifsglob.h"
>  #include "cifsproto.h"
>  #include "smb2proto.h"
> +#include "smb2pdu.h"
>  #include "cifs_debug.h"
>  #include "cifs_unicode.h"
>  #include "../common/smb2status.h"
> @@ -317,7 +318,7 @@ char *
>  smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
>  {
>         const int max_off =3D 4096;
> -       const int max_len =3D 128 * 1024;
> +       int max_len =3D 128 * 1024;
>
>         *off =3D 0;
>         *len =3D 0;
> @@ -368,6 +369,10 @@ smb2_get_data_area_len(int *off, int *len, struct sm=
b2_hdr *shdr)
>                   ((struct smb2_query_directory_rsp *)shdr)->OutputBuffer=
Offset);
>                 *len =3D le32_to_cpu(
>                   ((struct smb2_query_directory_rsp *)shdr)->OutputBuffer=
Length);
> +               /* Allow larger buffers for query directory (up to 2MB).
> +                * The actual data is handled separately in cifs_query_di=
r_receive().
> +                */
> +               max_len =3D SMB2_MAX_QD_DATABUF_SIZE;
>                 break;
>         case SMB2_IOCTL:
>                 *off =3D le32_to_cpu(
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index a7fe82e522de6..23115c943d4c5 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2721,11 +2721,134 @@ smb2_query_dir_first(const unsigned int xid, str=
uct cifs_tcon *tcon,
>
>  static int
>  smb2_query_dir_next(const unsigned int xid, struct cifs_tcon *tcon,
> -                   struct cifs_fid *fid, __u16 search_flags,
> -                   struct cifs_search_info *srch_inf)
> +                   struct cifs_sb_info *cifs_sb, struct cifs_fid *fid,
> +                   __u16 search_flags, struct cifs_search_info *srch_inf=
)
>  {
> -       return SMB2_query_directory(xid, tcon, fid->persistent_fid,
> -                                   fid->volatile_fid, 0, srch_inf);
> +       struct cifs_query_dir_io qd_io;
> +       struct TCP_Server_Info *server;
> +       struct cifs_ses *ses =3D tcon->ses;
> +       size_t buf_size;
> +       int rc;
> +       int resp_buftype =3D CIFS_DYNAMIC_BUFFER;
> +
> +       /* Pick server and determine buffer size based on negotiated rsiz=
e */
> +       server =3D cifs_pick_channel(ses);
> +       if (!server)
> +               return smb_EIO(smb_eio_trace_null_pointers);
> +
> +       /* Use negotiated transaction size for buffer size, with reasonab=
le limits */
> +       buf_size =3D tcon->ses->server->maxBuf;
> +       if (!buf_size) {
> +               /* cifsd could've marked the session for reconnect */
> +               rc =3D -EAGAIN;
> +               cifs_dbg(VFS, "%s: failed to get credits: %d\n", __func__=
, rc);
> +               return rc;
> +       }
> +
> +       cifs_dbg(FYI, "%s: using buffer size %zu (maxBuf=3D%u, encrypted=
=3D%d)\n",
> +                __func__, buf_size, tcon->ses->server->maxBuf, smb3_encr=
yption_required(tcon));
> +
> +       /* Initialize qd_io structure */
> +       memset(&qd_io, 0, sizeof(qd_io));
> +       qd_io.tcon =3D tcon;
> +       qd_io.server =3D server;
> +       qd_io.srch_inf =3D srch_inf;
> +       qd_io.xid =3D xid;
> +       qd_io.persistent_fid =3D fid->persistent_fid;
> +       qd_io.volatile_fid =3D fid->volatile_fid;
> +       qd_io.index =3D 0;
> +       qd_io.result =3D 0;
> +       qd_io.replay =3D false;
> +       qd_io.retries =3D 0;
> +       qd_io.cur_sleep =3D 0;
> +
> +       /* Allocate credits for the buffer size */
> +       rc =3D server->ops->wait_mtu_credits(server, buf_size, &buf_size,
> +                                          &qd_io.credits);
> +       if (rc) {
> +               cifs_dbg(VFS, "%s: failed to get credits: %d\n", __func__=
, rc);
> +               return rc;
> +       }
> +
> +       cifs_dbg(FYI, "%s: allocated %u credits for %zu bytes\n",
> +                __func__, qd_io.credits.value, buf_size);
> +
> +       /* Send query directory with large buffer and wait for completion=
 */
> +       rc =3D SMB2_query_directory_large(&qd_io, buf_size);
> +       if (rc) {
> +               if (rc =3D=3D -ENODATA) {
> +                       const struct smb2_hdr *hdr =3D NULL;
> +
> +                       if (qd_io.combined_iov.iov_base)
> +                               hdr =3D (const struct smb2_hdr *)qd_io.co=
mbined_iov.iov_base;
> +                       else if (qd_io.iov[0].iov_base)
> +                               hdr =3D (const struct smb2_hdr *)qd_io.io=
v[0].iov_base;
> +
> +                       /*
> +                        * ENODATA from QUERY_DIRECTORY generally means e=
numeration reached
> +                        * the end. Treat it as end-of-search even if the=
 header buffer is
> +                        * unavailable in this async path.
> +                        */
> +                       if (!hdr) {
> +                               cifs_dbg(FYI, "%s: ENODATA but hdr is NUL=
L\n", __func__);
> +                       } else {
> +                               cifs_dbg(FYI, "%s: ENODATA with hdr->Stat=
us=3D0x%x (STATUS_NO_MORE_FILES=3D0x%x)\n",
> +                                        __func__, le32_to_cpu(hdr->Statu=
s),
> +                                        le32_to_cpu(STATUS_NO_MORE_FILES=
));
> +                       }
> +
> +                       if (hdr && hdr->Status =3D=3D STATUS_NO_MORE_FILE=
S) {
> +                               trace_smb3_query_dir_done(xid, fid->persi=
stent_fid,
> +                                       tcon->tid, tcon->ses->Suid, 0, 0)=
;
> +                               srch_inf->endOfSearch =3D true;
> +                               rc =3D 0;
> +                       } else {
> +                               cifs_dbg(FYI, "%s: ENODATA but Status mis=
match - not treating as end-of-search\n",
> +                                       __func__);
> +                               trace_smb3_query_dir_err(xid, fid->persis=
tent_fid,
> +                                       tcon->tid, tcon->ses->Suid, 0, 0,=
 rc);
> +                       }
> +               } else {
> +                       trace_smb3_query_dir_err(xid, fid->persistent_fid=
,
> +                               tcon->tid, tcon->ses->Suid, 0, 0, rc);
> +               }
> +               goto qdir_next_exit;
> +       }
> +
> +       /* Parse the response using the combined buffer built in receive =
handler */
> +       if (qd_io.combined_iov.iov_len > 0) {
> +               rc =3D smb2_parse_query_directory(tcon, &qd_io.combined_i=
ov, resp_buftype,
> +                                               srch_inf);
> +               if (rc) {
> +                       trace_smb3_query_dir_err(xid, fid->persistent_fid=
,
> +                               tcon->tid, tcon->ses->Suid, 0, 0, rc);
> +                       kfree(qd_io.combined_iov.iov_base);
> +                       qd_io.combined_iov.iov_base =3D NULL;
> +                       goto qdir_next_exit;
> +               }
> +
> +               /* combined_iov.iov_base ownership transferred to srch_in=
f->ntwrk_buf_start */
> +               qd_io.combined_iov.iov_base =3D NULL;
> +
> +               trace_smb3_query_dir_done(xid, fid->persistent_fid,
> +                       tcon->tid, tcon->ses->Suid, 0,
> +                       srch_inf->entries_in_buffer);
> +       }
> +
> +qdir_next_exit:
> +       /* Free the data buffer if not transferred to srch_inf */
> +       kfree(qd_io.combined_iov.iov_base);
> +
> +       /* Return credits if we still have them (they should have been cl=
eared in callback) */
> +       if (qd_io.credits.value !=3D 0) {
> +               trace_smb3_rw_credits(0, 0, 0,
> +                                     server->credits, server->in_flight,
> +                                     qd_io.credits.value,
> +                                     cifs_trace_rw_credits_query_dir_don=
e);
> +               add_credits(server, &qd_io.credits, 0);
> +       }
> +
> +       return rc;
>  }
>
>  static int
> @@ -4842,6 +4965,252 @@ cifs_copy_folioq_to_iter(struct folio_queue *foli=
oq, size_t data_size,
>         return 0;
>  }
>
> +static int
> +cifs_copy_folioq_to_buf(struct folio_queue *folioq, size_t total_size,
> +                       size_t skip, char *buf, size_t buf_len)
> +{
> +       size_t copied =3D 0;
> +
> +       if (buf_len > total_size - skip)
> +               buf_len =3D total_size - skip;
> +
> +       for (; folioq; folioq =3D folioq->next) {
> +               for (int s =3D 0; s < folioq_count(folioq); s++) {
> +                       struct folio *folio =3D folioq_folio(folioq, s);
> +                       size_t fsize =3D folio_size(folio);
> +                       size_t len =3D umin(fsize - skip, buf_len);
> +
> +                       if (len =3D=3D 0)
> +                               break;
> +
> +                       memcpy_from_folio(buf + copied, folio, skip, len)=
;
> +                       copied +=3D len;
> +                       buf_len -=3D len;
> +                       skip =3D 0;
> +
> +                       if (buf_len =3D=3D 0)
> +                               return 0;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * Handle encrypted QueryDirectory response data.
> + * Called only for encrypted responses where mid->decrypted =3D=3D true.
> + * For unencrypted responses, cifs_query_dir_receive handles everything.
> + *
> + * This is written in such a way that handle_read_data does not need mod=
ification.
> + *
> + * buf: contains read_rsp_size bytes of decrypted response
> + * buffer: contains (total_len - read_rsp_size) bytes of decrypted data
> + *
> + * Since sizeof(struct smb2_query_directory_rsp) < read_rsp_size,
> + * the response header is always fully in buf. Data may be split between
> + * buf and buffer depending on data_offset.
> + */
> +static int
> +handle_query_dir_data(struct TCP_Server_Info *server, struct mid_q_entry=
 *mid,
> +                     char *buf, unsigned int buf_len, struct folio_queue=
 *buffer,
> +                     unsigned int buffer_len, bool is_offloaded)
> +{
> +       struct cifs_query_dir_io *qd_io =3D mid->callback_data;
> +       struct smb2_query_directory_rsp *rsp;
> +       struct smb2_hdr *shdr =3D (struct smb2_hdr *)buf;
> +       unsigned int data_offset, data_len;
> +       unsigned int hdr_len;
> +
> +       cifs_dbg(FYI, "%s: processing encrypted QueryDirectory response\n=
", __func__);
> +
> +       if (shdr->Command !=3D SMB2_QUERY_DIRECTORY) {
> +               cifs_server_dbg(VFS, "only QueryDirectory responses are s=
upported\n");
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (server->ops->is_session_expired &&
> +           server->ops->is_session_expired(buf)) {
> +               if (!is_offloaded)
> +                       cifs_reconnect(server, true);
> +               return -1;
> +       }
> +
> +       if (server->ops->is_status_pending &&
> +                       server->ops->is_status_pending(buf, server))
> +               return -1;
> +
> +       rsp =3D (struct smb2_query_directory_rsp *)buf;
> +       hdr_len =3D min_t(unsigned int, buf_len,
> +                        sizeof(struct smb2_query_directory_rsp));
> +
> +       /* Map error code first */
> +       qd_io->result =3D server->ops->map_error(buf, false);
> +
> +       /* Get data_offset early to set up iov properly */
> +       data_offset =3D le16_to_cpu(rsp->OutputBufferOffset);
> +       data_len =3D le32_to_cpu(rsp->OutputBufferLength);
> +
> +       /* Set up first iov to point to header portion (needed for credit=
s/signature) */
> +       qd_io->iov[0].iov_base =3D buf;
> +       qd_io->iov[0].iov_len =3D qd_io->result ? hdr_len : data_offset;
> +
> +       if (qd_io->result !=3D 0) {
> +               cifs_dbg(FYI, "%s: server returned error %d (Status=3D0x%=
x)\n",
> +                        __func__, qd_io->result, le32_to_cpu(rsp->hdr.St=
atus));
> +
> +               /*
> +                * Copy header to persistent combined_iov buffer so statu=
s
> +                * remains accessible after receive handler returns. buf =
is temporary
> +                * and will be freed/reused, so we can't leave iov[0] poi=
nting to it
> +                */
> +               if (qd_io->combined_iov.iov_base && hdr_len > 0 &&
> +                   hdr_len <=3D qd_io->combined_iov.iov_len) {
> +                       memcpy(qd_io->combined_iov.iov_base, buf, hdr_len=
);
> +                       qd_io->iov[0].iov_base =3D qd_io->combined_iov.io=
v_base;
> +                       qd_io->iov[0].iov_len =3D hdr_len;
> +                       cifs_dbg(FYI, "%s: copied error response header t=
o combined_iov\n",
> +                               __func__);
> +               }
> +
> +               /*
> +                * Normal error on query_directory response - response re=
ceived successfully,
> +                * but the command failed. Store error in qd_io->result f=
or callback
> +                */
> +               if (is_offloaded)
> +                       mid->mid_state =3D MID_RESPONSE_RECEIVED;
> +               else
> +                       dequeue_mid(server, mid, false);
> +               return 0;
> +       }
> +
> +       /* Success - parse the response data */
> +       cifs_dbg(FYI, "%s: data_offset=3D%u data_len=3D%u buf_len=3D%u bu=
ffer_len=3D%u\n",
> +                __func__, data_offset, data_len, buf_len, buffer_len);
> +
> +       /* Validate data_offset */
> +       if (data_offset < sizeof(struct smb2_query_directory_rsp)) {
> +               cifs_dbg(FYI, "%s: data offset (%u) inside response heade=
r\n",
> +                        __func__, data_offset);
> +               data_offset =3D sizeof(struct smb2_query_directory_rsp);
> +       } else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
> +               cifs_dbg(VFS, "%s: data offset (%u) beyond end of smallbu=
f\n",
> +                        __func__, data_offset);
> +               qd_io->result =3D -EIO;
> +               dequeue_mid(server, mid, qd_io->result);
> +               return qd_io->result;
> +       }
> +
> +       /* Validate data_offset is within buf_len + buffer_len */
> +       if (data_offset > buf_len + buffer_len) {
> +               cifs_dbg(VFS, "%s: data offset (%u) beyond response lengt=
h (%u)\n",
> +                        __func__, data_offset, buf_len + buffer_len);
> +               qd_io->result =3D -EIO;
> +               dequeue_mid(server, mid, qd_io->result);
> +               return qd_io->result;
> +       }
> +
> +       /* Validate response fits in pre-allocated combined buffer */
> +       if ((size_t)data_offset + data_len > qd_io->combined_iov.iov_len)=
 {
> +               cifs_dbg(VFS, "%s: response (%u + %u) exceeds buffer capa=
city (%zu)\n",
> +                        __func__, data_offset, data_len, qd_io->combined=
_iov.iov_len);
> +               qd_io->result =3D -EIO;
> +               dequeue_mid(server, mid, qd_io->result);
> +               return qd_io->result;
> +       }
> +
> +       /* Copy the prefix present in buf into combined_iov, preserving w=
ire layout */
> +       memcpy(qd_io->combined_iov.iov_base, buf, min(data_offset, buf_le=
n));
> +
> +       if (data_offset < buf_len) {
> +               /* Data starts in buf, may continue into buffer */
> +               unsigned int data_in_buf =3D buf_len - data_offset;
> +               unsigned int data_in_buffer;
> +
> +               if (data_len <=3D data_in_buf) {
> +                       /* All data is in buf */
> +                       memcpy(qd_io->combined_iov.iov_base + data_offset=
,
> +                              buf + data_offset, data_len);
> +               } else {
> +                       /* Copy from buf first */
> +                       memcpy(qd_io->combined_iov.iov_base + data_offset=
,
> +                              buf + data_offset, data_in_buf);
> +
> +                       /* Copy remainder from buffer at offset 0 */
> +                       data_in_buffer =3D data_len - data_in_buf;
> +                       if (data_in_buffer > buffer_len) {
> +                               cifs_dbg(VFS, "%s: data_in_buffer (%u) > =
buffer_len (%u)\n",
> +                                        __func__, data_in_buffer, buffer=
_len);
> +                               qd_io->result =3D -EIO;
> +                               dequeue_mid(server, mid, qd_io->result);
> +                               return qd_io->result;
> +                       }
> +
> +                       qd_io->result =3D cifs_copy_folioq_to_buf(buffer,=
 buffer_len, 0,
> +                                                               qd_io->co=
mbined_iov.iov_base +
> +                                                               data_offs=
et + data_in_buf,
> +                                                               data_in_b=
uffer);
> +                       if (qd_io->result !=3D 0) {
> +                               cifs_dbg(VFS, "%s: failed to copy from fo=
lio_queue: %d\n",
> +                                        __func__, qd_io->result);
> +                               dequeue_mid(server, mid, qd_io->result);
> +                               return qd_io->result;
> +                       }
> +               }
> +       } else {
> +               /* Padding and data are in buffer starting at offset 0 */
> +               unsigned int bytes_in_buffer =3D data_offset - buf_len + =
data_len;
> +
> +               if (bytes_in_buffer > buffer_len) {
> +                       cifs_dbg(VFS, "%s: data beyond buffer: prefix+len=
=3D%u buffer_len=3D%u\n",
> +                                __func__, bytes_in_buffer, buffer_len);
> +                       qd_io->result =3D -EIO;
> +                       dequeue_mid(server, mid, qd_io->result);
> +                       return qd_io->result;
> +               }
> +
> +               qd_io->result =3D cifs_copy_folioq_to_buf(buffer, buffer_=
len, 0,
> +                                                       qd_io->combined_i=
ov.iov_base + buf_len,
> +                                                       bytes_in_buffer);
> +               if (qd_io->result !=3D 0) {
> +                       cifs_dbg(VFS, "%s: failed to copy from folio_queu=
e: %d\n",
> +                                __func__, qd_io->result);
> +                       dequeue_mid(server, mid, qd_io->result);
> +                       return qd_io->result;
> +               }
> +       }
> +
> +       /* Set up iov[1] pointing into combined buffer, finalize valid le=
ngth */
> +       qd_io->iov[1].iov_base =3D qd_io->combined_iov.iov_base + data_of=
fset;
> +       qd_io->iov[1].iov_len =3D data_len;
> +       qd_io->combined_iov.iov_len =3D data_offset + data_len;
> +
> +       dequeue_mid(server, mid, false);
> +       return 0;
> +}
> +
> +/*
> + * Handle callback for async QueryDirectory with multi-credit support.
> + * For encrypted responses, extracts decrypted data.
> + * For unencrypted responses, cifs_query_dir_receive already processed e=
verything.
> + */
> +int
> +smb2_query_dir_handle_data(struct TCP_Server_Info *server, struct mid_q_=
entry *mid)
> +{
> +       char *buf =3D server->large_buf ? server->bigbuf : server->smallb=
uf;
> +
> +       /* For unencrypted responses, data already processed in cifs_quer=
y_dir_receive */
> +       if (!mid->decrypted)
> +               return 0;
> +
> +       /*
> +        * For small encrypted responses (< CIFSMaxBufSize), all data is =
in buf.
> +        * For large encrypted responses, this callback is not used - ins=
tead,
> +        * receive_encrypted_read/smb2_decrypt_offload call handle_query_=
dir_data directly.
> +        */
> +       return handle_query_dir_data(server, mid, buf, server->pdu_size,
> +                                     NULL, 0, false);
> +}
> +
>  static int
>  handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid=
,
>                  char *buf, unsigned int buf_len, struct folio_queue *buf=
fer,
> @@ -5005,25 +5374,46 @@ static void smb2_decrypt_offload(struct work_stru=
ct *work)
>         int rc;
>         struct mid_q_entry *mid;
>         struct iov_iter iter;
> +       struct smb2_hdr *shdr;
> +       unsigned int read_rsp_size =3D dw->server->vals->read_rsp_size;
>
> +       /* decrypt read_rsp_size in buf + remainder in folio_queue */
>         iov_iter_folio_queue(&iter, ITER_DEST, dw->buffer, 0, 0, dw->len)=
;
> -       rc =3D decrypt_raw_data(dw->server, dw->buf, dw->server->vals->re=
ad_rsp_size,
> -                             &iter, true);
> +       rc =3D decrypt_raw_data(dw->server, dw->buf, read_rsp_size, &iter=
, true);
>         if (rc) {
>                 cifs_dbg(VFS, "error decrypting rc=3D%d\n", rc);
>                 goto free_pages;
>         }
>
>         dw->server->lstrp =3D jiffies;
> +
> +       shdr =3D (struct smb2_hdr *)(dw->buf + sizeof(struct smb2_transfo=
rm_hdr));
> +
> +       /*
> +        * buf now contains read_rsp_size bytes after transform_hdr.
> +        * folio_queue contains (total_len - read_rsp_size) bytes.
> +        * The handle functions will determine where data actually starts=
 based on data_offset.
> +        */
> +
>         mid =3D smb2_find_dequeue_mid(dw->server, dw->buf);
>         if (mid =3D=3D NULL)
>                 cifs_dbg(FYI, "mid not found\n");
>         else {
>                 mid->decrypted =3D true;
> -               rc =3D handle_read_data(dw->server, mid, dw->buf,
> -                                     dw->server->vals->read_rsp_size,
> -                                     dw->buffer, dw->len,
> -                                     true);
> +
> +               /* Handle based on command type */
> +               if (shdr->Command =3D=3D SMB2_READ) {
> +                       rc =3D handle_read_data(dw->server, mid, dw->buf,=
 read_rsp_size,
> +                                             dw->buffer, dw->len, true);
> +               } else if (shdr->Command =3D=3D SMB2_QUERY_DIRECTORY) {
> +                       rc =3D handle_query_dir_data(dw->server, mid, dw-=
>buf, read_rsp_size,
> +                                                  dw->buffer, dw->len, t=
rue);
> +               } else {
> +                       cifs_dbg(VFS, "Unexpected command %u in decrypt o=
ffload\n",
> +                                le16_to_cpu(shdr->Command));
> +                       rc =3D -EOPNOTSUPP;
> +               }
> +
>                 if (rc >=3D 0) {
>  #ifdef CONFIG_CIFS_STATS2
>                         mid->when_received =3D jiffies;
> @@ -5067,9 +5457,10 @@ receive_encrypted_read(struct TCP_Server_Info *ser=
ver, struct mid_q_entry **mid,
>  {
>         char *buf =3D server->smallbuf;
>         struct smb2_transform_hdr *tr_hdr =3D (struct smb2_transform_hdr =
*)buf;
> +       struct smb2_hdr *shdr;
>         struct iov_iter iter;
> -       unsigned int len;
> -       unsigned int buflen =3D server->pdu_size;
> +       unsigned int len, total_len, buflen =3D server->pdu_size;
> +       unsigned int read_rsp_size =3D server->vals->read_rsp_size;
>         int rc;
>         struct smb2_decrypt_work *dw;
>
> @@ -5080,25 +5471,26 @@ receive_encrypted_read(struct TCP_Server_Info *se=
rver, struct mid_q_entry **mid,
>         dw->server =3D server;
>
>         *num_mids =3D 1;
> -       len =3D min_t(unsigned int, buflen, server->vals->read_rsp_size +
> +       total_len =3D le32_to_cpu(tr_hdr->OriginalMessageSize);
> +       if (total_len < read_rsp_size) {
> +               cifs_server_dbg(VFS, "OriginalMessageSize %u too small fo=
r read response (%u)\n",
> +                       total_len,
> +                       read_rsp_size);
> +               rc =3D -EINVAL;
> +               goto discard_data;
> +       }
> +
> +       /* Read transform_hdr + read_rsp_size into buf */
> +       len =3D min_t(unsigned int, buflen, read_rsp_size +
>                 sizeof(struct smb2_transform_hdr)) - HEADER_SIZE(server) =
+ 1;
>
>         rc =3D cifs_read_from_socket(server, buf + HEADER_SIZE(server) - =
1, len);
> -       if (rc < 0)
> +       if (rc < 0 || rc < len)
>                 goto free_dw;
>         server->total_read +=3D rc;
>
> -       if (le32_to_cpu(tr_hdr->OriginalMessageSize) <
> -           server->vals->read_rsp_size) {
> -               cifs_server_dbg(VFS, "OriginalMessageSize %u too small fo=
r read response (%zu)\n",
> -                       le32_to_cpu(tr_hdr->OriginalMessageSize),
> -                       server->vals->read_rsp_size);
> -               rc =3D -EINVAL;
> -               goto discard_data;
> -       }
> -       len =3D le32_to_cpu(tr_hdr->OriginalMessageSize) -
> -               server->vals->read_rsp_size;
> -       dw->len =3D len;
> +       /* Read remaining data into folio_queue */
> +       dw->len =3D total_len - read_rsp_size;
>         len =3D round_up(dw->len, PAGE_SIZE);
>
>         size_t cur_size =3D 0;
> @@ -5127,7 +5519,7 @@ receive_encrypted_read(struct TCP_Server_Info *serv=
er, struct mid_q_entry **mid,
>                 goto free_pages;
>
>         /*
> -        * For large reads, offload to different thread for better perfor=
mance,
> +        * For large responses, offload to different thread for better pe=
rformance,
>          * use more cores decrypting which can be expensive
>          */
>
> @@ -5141,20 +5533,41 @@ receive_encrypted_read(struct TCP_Server_Info *se=
rver, struct mid_q_entry **mid,
>                 return -1;
>         }
>
> -       rc =3D decrypt_raw_data(server, buf, server->vals->read_rsp_size,
> -                             &iter, false);
> +       /* Decrypt: read_rsp_size in buf + remainder in folio_queue */
> +       rc =3D decrypt_raw_data(server, buf, read_rsp_size, &iter, false)=
;
>         if (rc)
>                 goto free_pages;
>
> +       shdr =3D (struct smb2_hdr *) buf;
> +
> +       /*
> +        * buf now contains the complete response header (read_rsp_size b=
ytes).
> +        * folio_queue contains (total_len - read_rsp_size) bytes.
> +        * The handle functions will determine where data actually starts=
 based on data_offset.
> +        */
> +
>         *mid =3D smb2_find_mid(server, buf);
>         if (*mid =3D=3D NULL) {
>                 cifs_dbg(FYI, "mid not found\n");
>         } else {
> -               cifs_dbg(FYI, "mid found\n");
> +               cifs_dbg(FYI, "mid found, command=3D%u\n", le16_to_cpu(sh=
dr->Command));
>                 (*mid)->decrypted =3D true;
> -               rc =3D handle_read_data(server, *mid, buf,
> -                                     server->vals->read_rsp_size,
> -                                     dw->buffer, dw->len, false);
> +
> +               /* Handle based on command type */
> +               if (shdr->Command =3D=3D SMB2_READ) {
> +                       rc =3D handle_read_data(server, *mid, buf, read_r=
sp_size,
> +                                             dw->buffer, dw->len, false)=
;
> +               } else if (shdr->Command =3D=3D SMB2_QUERY_DIRECTORY) {
> +                       rc =3D handle_query_dir_data(server, *mid, buf, r=
ead_rsp_size,
> +                                                  dw->buffer, dw->len, f=
alse);
> +               } else {
> +                       /* For now, other commands not supported in large=
 encrypted path */
> +                       cifs_server_dbg(VFS,
> +                                       "Large encrypted responses only s=
upported for SMB2_READ and SMB2_QUERY_DIRECTORY (got %u)\n",
> +                                       le16_to_cpu(shdr->Command));
> +                       rc =3D -EOPNOTSUPP;
> +               }
> +
>                 if (rc >=3D 0) {
>                         if (server->ops->is_network_name_deleted) {
>                                 server->ops->is_network_name_deleted(buf,
> @@ -5295,7 +5708,6 @@ smb3_receive_transform(struct TCP_Server_Info *serv=
er,
>                 return -ECONNABORTED;
>         }
>
> -       /* TODO: add support for compounds containing READ. */
>         if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server)) {
>                 return receive_encrypted_read(server, &mids[0], num_mids)=
;
>         }
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index eb471213df463..61ee639b64de0 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5506,6 +5506,185 @@ num_entries(int infotype, char *bufstart, char *e=
nd_of_buf, char **lastentry,
>         return entrycount;
>  }
>
> +/*
> + * Callback for async QueryDirectory with multi-credit support
> + */
> +static void
> +smb2_query_dir_callback(struct TCP_Server_Info *server, struct mid_q_ent=
ry *mid)
> +{
> +       struct cifs_query_dir_io *qd_io =3D mid->callback_data;
> +       struct cifs_tcon *tcon =3D qd_io->tcon;
> +       struct smb2_hdr *shdr =3D (struct smb2_hdr *)qd_io->iov[0].iov_ba=
se;
> +       struct cifs_credits credits =3D {
> +               .value =3D 0,
> +               .instance =3D 0,
> +       };
> +
> +       WARN_ONCE(qd_io->server !=3D server,
> +                 "qd_io server %p !=3D mid server %p",
> +                 qd_io->server, server);
> +
> +       cifs_dbg(FYI, "%s: mid=3D%llu state=3D%d result=3D%d\n",
> +                __func__, mid->mid, mid->mid_state, qd_io->result);
> +
> +       switch (mid->mid_state) {
> +       case MID_RESPONSE_RECEIVED:
> +               credits.value =3D le16_to_cpu(shdr->CreditRequest);
> +               credits.instance =3D server->reconnect_instance;
> +               /* result already set, check signature if needed */
> +               if (server->sign && !mid->decrypted) {
> +                       int rc;
> +                       struct smb_rqst rqst =3D {
> +                               .rq_iov =3D &qd_io->iov[0],
> +                               .rq_nvec =3D qd_io->iov[1].iov_len ? 2 : =
1,
> +                       };
> +
> +                       rc =3D smb2_verify_signature(&rqst, server);
> +                       if (rc) {
> +                               cifs_tcon_dbg(VFS, "QueryDir signature ve=
rification returned error =3D %d\n",
> +                                             rc);
> +                               qd_io->result =3D rc;
> +                       }
> +               }
> +               break;
> +       case MID_REQUEST_SUBMITTED:
> +       case MID_RETRY_NEEDED:
> +               qd_io->result =3D -EAGAIN;
> +               break;
> +       case MID_RESPONSE_MALFORMED:
> +               credits.value =3D le16_to_cpu(shdr->CreditRequest);
> +               credits.instance =3D server->reconnect_instance;
> +               qd_io->result =3D smb_EIO(smb_eio_trace_read_rsp_malforme=
d);
> +               break;
> +       default:
> +               qd_io->result =3D smb_EIO1(smb_eio_trace_read_mid_state_u=
nknown,
> +                                        mid->mid_state);
> +               break;
> +       }
> +
> +       if (qd_io->result && qd_io->result !=3D -ENODATA)
> +               cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
> +
> +       trace_smb3_rw_credits(0, 0, qd_io->credits.value,
> +                             server->credits, server->in_flight,
> +                             0, cifs_trace_rw_credits_read_response_clea=
r);
> +       qd_io->credits.value =3D 0;
> +       release_mid(server, mid);
> +       trace_smb3_rw_credits(0, 0, 0,
> +                             server->credits, server->in_flight,
> +                             credits.value, cifs_trace_rw_credits_read_r=
esponse_add);
> +       add_credits(server, &credits, 0);
> +
> +       complete(&qd_io->done);
> +}
> +
> +/*
> + * QueryDirectory with large buffer and multi-credit support.
> + * Uses async infrastructure but waits for completion synchronously.
> + */
> +int
> +SMB2_query_directory_large(struct cifs_query_dir_io *qd_io, unsigned int=
 buf_size)
> +{
> +       int rc, flags =3D 0;
> +       char *buf;
> +       struct smb2_hdr *shdr;
> +       struct smb_rqst rqst =3D { .rq_iov =3D &qd_io->iov[0],
> +                                .rq_nvec =3D SMB2_QUERY_DIRECTORY_IOV_SI=
ZE };
> +       struct TCP_Server_Info *server =3D qd_io->server;
> +       struct cifs_tcon *tcon =3D qd_io->tcon;
> +       unsigned int total_len;
> +       int credit_request;
> +
> +       cifs_dbg(FYI, "%s: buf_size=3D%u\n", __func__, buf_size);
> +
> +       /* Cap buffer size to avoid kmalloc failures for very large alloc=
ations.
> +        * SMB2_MAX_QD_DATABUF_SIZE is a safe limit that stays well below=
 typical
> +        * kmalloc constraints while still allowing large directory listi=
ngs.
> +        */
> +       if (buf_size > SMB2_MAX_QD_DATABUF_SIZE)
> +               buf_size =3D SMB2_MAX_QD_DATABUF_SIZE;
> +
> +       /* Allocate response buffer. Since we'll build a combined header+=
data buffer,
> +        * we need space for both. We'll request a slightly smaller Outpu=
tBufferLength
> +        * from the server to ensure the total response fits.
> +        */
> +       qd_io->combined_iov.iov_base =3D kmalloc(buf_size, GFP_KERNEL);
> +       if (!qd_io->combined_iov.iov_base)
> +               return -ENOMEM;
> +       /* Store total capacity in iov_len; updated to actual data length=
 by receive handler */
> +       qd_io->combined_iov.iov_len =3D buf_size;
> +
> +       /* Initialize completion */
> +       init_completion(&qd_io->done);
> +
> +       /* Request less data from server to leave room for the response h=
eader.
> +        * Use MAX_CIFS_SMALL_BUFFER_SIZE as a safety margin.
> +        */
> +       rc =3D SMB2_query_directory_init(qd_io->xid, tcon, server,
> +                                      &rqst, qd_io->persistent_fid,
> +                                      qd_io->volatile_fid, qd_io->index,
> +                                      qd_io->srch_inf->info_level,
> +                                      buf_size - MAX_CIFS_SMALL_BUFFER_S=
IZE);
> +       if (rc) {
> +               kfree(qd_io->combined_iov.iov_base);
> +               qd_io->combined_iov.iov_base =3D NULL;
> +               return rc;
> +       }
> +
> +       if (smb3_encryption_required(tcon))
> +               flags |=3D CIFS_TRANSFORM_REQ;
> +
> +       buf =3D rqst.rq_iov[0].iov_base;
> +       total_len =3D rqst.rq_iov[0].iov_len;
> +
> +       shdr =3D (struct smb2_hdr *)buf;
> +
> +       if (qd_io->replay) {
> +               /* Back-off before retry */
> +               if (qd_io->cur_sleep)
> +                       msleep(qd_io->cur_sleep);
> +               smb2_set_replay(server, &rqst);
> +       }
> +
> +       /* Set credit charge based on buffer size */
> +       if (qd_io->credits.value > 0) {
> +               shdr->CreditCharge =3D cpu_to_le16(DIV_ROUND_UP(buf_size,
> +                                               SMB2_MAX_BUFFER_SIZE));
> +               credit_request =3D le16_to_cpu(shdr->CreditCharge) + 8;
> +               if (server->credits >=3D server->max_credits)
> +                       shdr->CreditRequest =3D cpu_to_le16(0);
> +               else
> +                       shdr->CreditRequest =3D cpu_to_le16(
> +                               min_t(int, server->max_credits -
> +                                               server->credits, credit_r=
equest));
> +
> +               flags |=3D CIFS_HAS_CREDITS;
> +       }
> +
> +       rc =3D cifs_call_async(server, &rqst,
> +                            cifs_query_dir_receive, smb2_query_dir_callb=
ack,
> +                            smb2_query_dir_handle_data, qd_io, flags,
> +                            &qd_io->credits);
> +       if (rc) {
> +               cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
> +               trace_smb3_query_dir_err(qd_io->xid, qd_io->persistent_fi=
d,
> +                                        tcon->tid, tcon->ses->Suid,
> +                                        qd_io->index, 0, rc);
> +               kfree(qd_io->combined_iov.iov_base);
> +               qd_io->combined_iov.iov_base =3D NULL;
> +       }
> +
> +       /* Free request buffer immediately after async call */
> +       cifs_small_buf_release(buf);
> +
> +       if (rc)
> +               return rc;
> +
> +       /* Wait for the async operation to complete */
> +       wait_for_completion(&qd_io->done);
> +       return qd_io->result;
> +}
> +
>  /*
>   * Readdir/FindFirst
>   */
> @@ -5570,12 +5749,6 @@ int SMB2_query_directory_init(const unsigned int x=
id,
>         req->FileNameOffset =3D
>                 cpu_to_le16(sizeof(struct smb2_query_directory_req));
>         req->FileNameLength =3D cpu_to_le16(len);
> -       /*
> -        * BB could be 30 bytes or so longer if we used SMB2 specific
> -        * buffer lengths, but this is safe and close enough.
> -        */
> -       output_size =3D min_t(unsigned int, output_size, server->maxBuf);
> -       output_size =3D min_t(unsigned int, output_size, 2 << 15);
>         req->OutputBufferLength =3D cpu_to_le32(output_size);
>
>         iov[0].iov_base =3D (char *)req;
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 7b7a864520c68..843e30c1ecc61 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -132,6 +132,9 @@ struct share_redirect_error_context_rsp {
>  /* Size of the minimal QueryDir response for checking if more data exist=
s */
>  #define SMB2_QD2_RESPONSE_SIZE 4096
>
> +/* max query directory data buffer size */
> +#define SMB2_MAX_QD_DATABUF_SIZE (2 * 1024 * 1024)
> +
>  /*
>   * Output buffer size for first QueryDir in Create+QD1+QD2 compound.
>   * Accounts for shared buffer space needed for all three responses.
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 6b4dc4fea21e8..b299e097aa525 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -51,6 +51,8 @@ __le32 smb2_get_lease_state(struct cifsInodeInfo *cinod=
e, unsigned int oplock);
>  bool smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *se=
rver);
>  int smb3_handle_read_data(struct TCP_Server_Info *server,
>                           struct mid_q_entry *mid);
> +int smb2_query_dir_handle_data(struct TCP_Server_Info *server,
> +                              struct mid_q_entry *mid);
>  struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data=
,
>                                         struct super_block *sb,
>                                         const unsigned int xid,
> @@ -202,6 +204,7 @@ int SMB2_query_directory_init(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                               u64 volatile_fid, int index, int info_level=
,
>                               unsigned int output_size);
>  void SMB2_query_directory_free(struct smb_rqst *rqst);
> +int SMB2_query_directory_large(struct cifs_query_dir_io *qd_io, unsigned=
 int buf_size);
>  int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
>                  u64 persistent_fid, u64 volatile_fid, u32 pid,
>                  loff_t new_eof);
> diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> index b99ec5a417fad..9e120d6fe51cf 100644
> --- a/fs/smb/client/trace.h
> +++ b/fs/smb/client/trace.h
> @@ -165,6 +165,7 @@
>         EM(cifs_trace_rw_credits_write_prepare,         "wr-prepare ") \
>         EM(cifs_trace_rw_credits_write_response_add,    "wr-resp-add") \
>         EM(cifs_trace_rw_credits_write_response_clear,  "wr-resp-clr") \
> +       EM(cifs_trace_rw_credits_query_dir_done,        "qd-done    ") \
>         E_(cifs_trace_rw_credits_zero_in_flight,        "ZERO-IN-FLT")
>
>  #define smb3_tcon_ref_traces                                         \
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 05f8099047e1a..eb3dce4449963 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -1134,7 +1134,7 @@ cifs_discard_remaining_data(struct TCP_Server_Info =
*server)
>  }
>
>  static int
> -__cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry =
*mid,
> +__cifs_discard_and_dequeue(struct TCP_Server_Info *server, struct mid_q_=
entry *mid,
>                      bool malformed)
>  {
>         int length;
> @@ -1146,12 +1146,162 @@ __cifs_readv_discard(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid,
>         return length;
>  }
>
> -static int
> -cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *m=
id)
> +/*
> + * Receive handler for async QueryDirectory with multi-credit support
> + */
> +int
> +cifs_query_dir_receive(struct TCP_Server_Info *server, struct mid_q_entr=
y *mid)
>  {
> -       struct cifs_io_subrequest *rdata =3D mid->callback_data;
> +       int length, len;
> +       unsigned int data_offset, data_len, resp_size;
> +       struct cifs_query_dir_io *qd_io =3D mid->callback_data;
> +       char *buf =3D server->smallbuf;
> +       unsigned int buflen =3D server->pdu_size;
> +       struct smb2_query_directory_rsp *rsp;
> +
> +       cifs_dbg(FYI, "%s: mid=3D%llu buf_capacity=3D%zu\n",
> +                __func__, mid->mid, qd_io->combined_iov.iov_len);
> +
> +       /*
> +        * Read the rest of QUERY_DIRECTORY_RSP header (sans Data array).
> +        * QueryDirectory response structure is 64 bytes (SMB2 header) + =
8 bytes (fixed part).
> +        */
> +       resp_size =3D sizeof(struct smb2_query_directory_rsp);
> +       len =3D min_t(unsigned int, buflen, resp_size) - HEADER_SIZE(serv=
er) + 1;
> +
> +       length =3D cifs_read_from_socket(server,
> +                                      buf + HEADER_SIZE(server) - 1, len=
);
> +       if (length < 0) {
> +               qd_io->result =3D length;
> +               return __cifs_discard_and_dequeue(server, mid, false);
> +       }
> +       server->total_read +=3D length;
> +
> +       if (server->ops->is_session_expired &&
> +           server->ops->is_session_expired(buf)) {
> +               cifs_reconnect(server, true);
> +               return -1;
> +       }
> +
> +       if (server->ops->is_status_pending &&
> +           server->ops->is_status_pending(buf, server)) {
> +               cifs_discard_remaining_data(server);
> +               return -1;
> +       }
> +
> +       /* Is there enough to get to the rest of the QUERY_DIRECTORY_RSP =
header? */
> +       if (server->total_read < resp_size) {
> +               cifs_dbg(FYI, "%s: server returned short header. got=3D%u=
 expected=3D%u\n",
> +                        __func__, server->total_read, resp_size);
> +               qd_io->result =3D smb_EIO2(smb_eio_trace_read_rsp_short,
> +                                        server->total_read, resp_size);
> +               return __cifs_discard_and_dequeue(server, mid, true);
> +       }
> +
> +       /* Set up first iov for signature check and to get credits */
> +       qd_io->iov[0].iov_base =3D buf;
> +       qd_io->iov[0].iov_len =3D server->total_read;
> +       qd_io->iov[1].iov_base =3D NULL;
> +       qd_io->iov[1].iov_len =3D 0;
> +       cifs_dbg(FYI, "0: iov_base=3D%p iov_len=3D%zu\n",
> +                qd_io->iov[0].iov_base, qd_io->iov[0].iov_len);
> +
> +       /* Parse header early to access status before map_error converts =
it */
> +       rsp =3D (struct smb2_query_directory_rsp *)buf;
> +
> +       /* Was the SMB query_directory successful? */
> +       qd_io->result =3D server->ops->map_error(buf, false);
> +       if (qd_io->result !=3D 0) {
> +               if (qd_io->combined_iov.iov_base && qd_io->iov[0].iov_len=
 > 0 &&
> +                   qd_io->iov[0].iov_len <=3D qd_io->combined_iov.iov_le=
n) {
> +                       memcpy(qd_io->combined_iov.iov_base, qd_io->iov[0=
].iov_base,
> +                              qd_io->iov[0].iov_len);
> +                       qd_io->iov[0].iov_base =3D qd_io->combined_iov.io=
v_base;
> +               }
> +               cifs_dbg(FYI, "%s: server returned error %d (Status was 0=
x%x)\n",
> +                        __func__, qd_io->result, le32_to_cpu(rsp->hdr.St=
atus));
> +               return __cifs_discard_and_dequeue(server, mid, false);
> +       }
> +
> +       data_offset =3D le16_to_cpu(rsp->OutputBufferOffset);
> +       data_len =3D le32_to_cpu(rsp->OutputBufferLength);
> +
> +       cifs_dbg(FYI, "%s: total_read=3D%u data_offset=3D%u data_len=3D%u=
\n",
> +                __func__, server->total_read, data_offset, data_len);
> +
> +       /* Validate data_offset and data_len */
> +       if (data_offset < server->total_read) {
> +               cifs_dbg(FYI, "%s: data offset (%u) inside response heade=
r\n",
> +                        __func__, data_offset);
> +               data_offset =3D server->total_read;
> +               data_len =3D 0;
> +       } else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
> +               cifs_dbg(FYI, "%s: data offset (%u) beyond end of smallbu=
f\n",
> +                        __func__, data_offset);
> +               qd_io->result =3D smb_EIO1(smb_eio_trace_read_overlarge,
> +                                        data_offset);
> +               return __cifs_discard_and_dequeue(server, mid, true);
> +       }
> +
> +       /* Read any padding between header and data */
> +       len =3D data_offset - server->total_read;
> +       if (len > 0) {
> +               length =3D cifs_read_from_socket(server,
> +                                              buf + server->total_read, =
len);
> +               if (length < 0) {
> +                       qd_io->result =3D length;
> +                       return __cifs_discard_and_dequeue(server, mid, fa=
lse);
> +               }
> +               server->total_read +=3D length;
> +               qd_io->iov[0].iov_len =3D server->total_read;
> +       }
> +
> +       /* Check if data fits in the pre-allocated combined buffer */
> +       if (qd_io->iov[0].iov_len + data_len > qd_io->combined_iov.iov_le=
n) {
> +               cifs_dbg(VFS, "%s: response (%zu + %u) exceeds buffer cap=
acity (%zu)\n",
> +                        __func__, qd_io->iov[0].iov_len, data_len, qd_io=
->combined_iov.iov_len);
> +               qd_io->result =3D smb_EIO2(smb_eio_trace_read_rsp_malform=
ed,
> +                                        data_len, (unsigned int)qd_io->c=
ombined_iov.iov_len);
> +               return __cifs_discard_and_dequeue(server, mid, true);
> +       }
> +
> +       /*
> +        * Build combined header+data in qd_io->combined_iov.iov_base,
> +        * preserving the wire layout so SMB2 signing can be verified aga=
inst
> +        * the exact on-the-wire bytes.  hdr_len already accounts for the
> +        * header and any padding up to data_offset; data is read at that
> +        * same offset.  OutputBufferOffset/Length are left untouched.
> +        */
> +       if (qd_io->iov[0].iov_len > 0 && qd_io->result =3D=3D 0) {
> +               size_t hdr_len =3D qd_io->iov[0].iov_len;
> +
> +               /* Copy header+padding to combined buffer, preserving wir=
e layout */
> +               memcpy(qd_io->combined_iov.iov_base, qd_io->iov[0].iov_ba=
se, hdr_len);
> +
> +               /* Read directory entries at the wire data_offset positio=
n */
> +               if (data_len > 0) {
> +                       length =3D cifs_read_from_socket(server,
> +                                                      qd_io->combined_io=
v.iov_base + hdr_len,
> +                                                      data_len);
> +                       if (length < 0) {
> +                               qd_io->result =3D length;
> +                               return __cifs_discard_and_dequeue(server,=
 mid, false);
> +                       }
> +                       server->total_read +=3D length;
> +
> +                       /* Set up second iov pointing to the directory da=
ta within combined buffer */
> +                       qd_io->iov[1].iov_base =3D qd_io->combined_iov.io=
v_base + hdr_len;
> +                       qd_io->iov[1].iov_len =3D length;
> +               }
> +
> +               qd_io->combined_iov.iov_len =3D hdr_len + (data_len > 0 ?=
 length : 0);
> +
> +               cifs_dbg(FYI, "total_read=3D%u buflen=3D%u data_len=3D%u =
hdr_len=3D%zu combined_len=3D%zu\n",
> +                        server->total_read, buflen, data_len, hdr_len,
> +                        qd_io->combined_iov.iov_len);
> +       }
>
> -       return  __cifs_readv_discard(server, mid, rdata->result);
> +       return __cifs_discard_and_dequeue(server, mid, false);
>  }
>
>  int
> @@ -1205,7 +1355,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, =
struct mid_q_entry *mid)
>                 cifs_dbg(FYI, "%s: server returned error %d\n",
>                          __func__, rdata->result);
>                 /* normal error on read response */
> -               return __cifs_readv_discard(server, mid, false);
> +               return __cifs_discard_and_dequeue(server, mid, false);
>         }
>
>         /* Is there enough to get to the rest of the READ_RSP header? */
> @@ -1215,7 +1365,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, =
struct mid_q_entry *mid)
>                          server->vals->read_rsp_size);
>                 rdata->result =3D smb_EIO2(smb_eio_trace_read_rsp_short,
>                                          server->total_read, server->vals=
->read_rsp_size);
> -               return cifs_readv_discard(server, mid);
> +               return __cifs_discard_and_dequeue(server, mid, rdata->res=
ult);
>         }
>
>         data_offset =3D server->ops->read_data_offset(buf);
> @@ -1234,7 +1384,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, =
struct mid_q_entry *mid)
>                          __func__, data_offset);
>                 rdata->result =3D smb_EIO1(smb_eio_trace_read_overlarge,
>                                          data_offset);
> -               return cifs_readv_discard(server, mid);
> +               return __cifs_discard_and_dequeue(server, mid, rdata->res=
ult);
>         }
>
>         cifs_dbg(FYI, "%s: total_read=3D%u data_offset=3D%u\n",
> @@ -1260,7 +1410,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, =
struct mid_q_entry *mid)
>                 /* data_len is corrupt -- discard frame */
>                 rdata->result =3D smb_EIO2(smb_eio_trace_read_rsp_malform=
ed,
>                                          data_offset + data_len, buflen);
> -               return cifs_readv_discard(server, mid);
> +               return __cifs_discard_and_dequeue(server, mid, rdata->res=
ult);
>         }
>
>  #ifdef CONFIG_CIFS_SMB_DIRECT
> @@ -1279,7 +1429,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, =
struct mid_q_entry *mid)
>
>         /* discard anything left over */
>         if (server->total_read < buflen)
> -               return cifs_readv_discard(server, mid);
> +               return __cifs_discard_and_dequeue(server, mid, rdata->res=
ult);
>
>         dequeue_mid(server, mid, false);
>         mid->resp_buf =3D server->smallbuf;
> --
> 2.43.0
>


--=20
Thanks,

Steve
