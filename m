Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD0C339844
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 23:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776294718; cv=pass; b=jOP3BHkJMfxLBsQlN4qZ28CAoNOrxtw8+AViD/1z9Yda4QJMRPKXYiKEg/kH0LeOwhFI6qcHrJ9UEXW+0qK0xtkshSxpibe28a0GxayrWmjU3VmAxaOhM/m5LtQyTqen30eQHzdfB1K8HHoDPMvLLiaX8Rokwo0s/dx32VUCN0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776294718; c=relaxed/simple;
	bh=DOQtnUyz7zB3JaZIQw/04PomLt4rNW6hOqPfZWYw0iI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FRa56wYoNGOWRX3kTUMn2tm+RCWZHQ2AslkHq4eLDeMwo/sU4ycnE0onQ4iElociWYreYPj6NAbxvD7CXew+iKHRjntWIX1CY3OWmIB//bj7taBxoty86b39rUD2GS1oz9WbeujgKwz+rlcnmPoOVJhQ/2Z4IsxnIx7nJprStFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LrnicgE/; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LrnicgE/"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8acb3dab8dfso25141316d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 16:11:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776294714; cv=none;
        d=google.com; s=arc-20240605;
        b=NV7zyNMzccPpDHDuAChMUAFkgiRtR4RIxwmDIIhXPReSQeuAAynqvEk6SbMRmANSrZ
         2Ttf2R8/CayGb0katUy+5vg4kI25zbkF9gUs8A+geE8mhd5jSL9jqQGWp2J/4bTtXi9R
         wYYjVEwH+lTELtpyShWtB9lKQnsiELs85+lgV6AqJ2HYJ++5rbO/wduVffbIDqZQF3G4
         vfQ6hXSNyeVsnwY6uMHXoM9kJoiRQ/hf38X+ejgyBF0svd02UnVEGgg6lzJ3euHCDRGW
         s9vJ8fAGjHslEZ8Q5vY9Dew3oL5T4kozf6X6+O6pgaaORoeILQ1CA0D0KZ74S0SUBqPn
         cvjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J9PRteQ2ZGIBR67mRzd+kVN+Pn+x2zWEHcDEf+3OR4I=;
        fh=rp0FA5AMMFhnvd+7CH3i/3/7H4yxlYkrZz/XeOB1x7E=;
        b=aOXFAclpxvdc6p7/GOscBSbbE38Rstjb445Nos/Ju0MhK4DCa3mzIYQO1trxb87gb1
         5uNns60YUfP4OJr00UR/DsPvdPixZfjy1/utB6g3Kw8geYsInGsXX/6eU/iIj22mKtO5
         JjUbsPHf4vtYSgFGHRnKsAVDvpidNx9U3SiuHSfkKOFA8igvKeW/RPRvqeHkTlr8VADN
         sABBhZM6/QbehCirfWxKQnVodk14jHpkx0OlF1sICh5Z3AVYX8wt0GdmEs+LdPaI9nwU
         TFpcIBTKNLyr1k3QNVGLsFESpTq+HIpPbq384rXcesfgbZ3Dhm0p213pHRmX4Aiw8Lax
         gocA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776294714; x=1776899514; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9PRteQ2ZGIBR67mRzd+kVN+Pn+x2zWEHcDEf+3OR4I=;
        b=LrnicgE/i9EpSPRpd9tTVXAB1Ux3rQ/4ODi4zHgI/uOA4FdxfwiShGQG0iz+tNr5kr
         UPFdf6TsPl6KmX63mBZ9r7IzXMr6S3YKtr/13AdkoNRp8HPp7lpBhnrDkg253qlnwBfM
         bn4Upkjj1GLeTZyVOlMdSL7MFuxsNgGK7C1oqIjrcya95QdMZy7xPON8SJIE8n0xp3Ry
         QxbBYxrPtswFEx7WBnoUS2XswBqWW9W7cqHrcWYz/VeT0yD3dZJQC4KRUA3Rcur6gGyC
         CHN7ZPVu2LhbKtaOL9GlavjOQQHU1kW5jqYC+XBd7ZLLsmim26pxy3p1lz3aXR09hC+H
         vVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776294714; x=1776899514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J9PRteQ2ZGIBR67mRzd+kVN+Pn+x2zWEHcDEf+3OR4I=;
        b=bLkuE2RLbp8LI4Mi7quRIjqOhfv8nKJ1ECX0mWlI+9NYQ/UDdeOLJZMBpwVkMmDZdh
         3/dcHQ/SXCiUO2LbIsgDikOk1A956qnbzsidYigT/mWDyz4U42h45tks5+93b3nRSRm2
         4duOgwAfT74m3T7QNHpnuhEU+r6GX4lcsr/ZCXUorjg/wTe3lck6f3cHj0ofm0RieMEN
         pDcCt+Bip5bvfaB6daXzqZSSIZ1MeWaeWRoG3aXzeGrv5CoLdkrvqS0oaKdUH9eOjo2u
         E9cpYUodcfzVdVqvAIEjQ/46p6N0okrxEGS3w3wMt0U0hk3JerrZhO5TtZ7d/kodUUTX
         INuA==
X-Gm-Message-State: AOJu0YzbLJ9o17tqIWEtqu9elIQjvp1KoCx5H+UxEAjb/B03fuuOS2z1
	+3LjV3A4qaPfG4JeCNi6eIIVsKXnh5EgvpCq5nFFPNyw5mv/VBRNYgFxASZoyG1e04x26+0MBTm
	COKarM5TAUem9NVYtpPbfG1rPXYMwI24=
X-Gm-Gg: AeBDievLG1tB63mkRsxtbhzjS7iue1hAf9sp6Kq0uwsp72WpCwaNm2eOOCgnRINafZD
	AFRbGF3qC8FUndlGpu3xiP1PVm7jks+FccTRtblHrPyGJ/4Ww/VvE8Y8VDvgCktwk39Ego1wbDG
	+sp7tkCfnmqgttujgIaZOt0ceHkJi4xnTo6oWEeds1jfVBZrTmIwnhSOpxRhnHnCTfzPoBXgZ2C
	9gqTdzojFxTz5DB3G4wcq0J+05sYnr5865gBiS7OC26zfS3ATjNs4YpJaz58upzbPlQu9OOgwN8
	tSNzBIKb9mSpGAgutkkfcf1Px3g0+vrYWF2x2eYDI3NpWrkvcp9fZiWmjmIaJAg49zyqY9J3ikV
	nzbyPqUSWhCY3Bc93kvMeras/Yy8fUn1Yvo7cNttDozDPjjwVlDdQSdbUi+t40OaINADzVAZGZd
	KejxamrZjBWPAW7w+ceI+kymY0pTzKvWdX
X-Received: by 2002:a05:6214:2b91:b0:8a1:c536:57de with SMTP id
 6a1803df08f44-8ac86254f9dmr383740856d6.48.1776294713517; Wed, 15 Apr 2026
 16:11:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260414135918.279802-1-sprasad@microsoft.com>
 <20260414135918.279802-6-sprasad@microsoft.com> <CAH2r5msv61YpML_1fwrtTbxcGu48jn9KE4K46BkUoJPepSSwAg@mail.gmail.com>
In-Reply-To: <CAH2r5msv61YpML_1fwrtTbxcGu48jn9KE4K46BkUoJPepSSwAg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 15 Apr 2026 18:11:41 -0500
X-Gm-Features: AQROBzBuVDJcKgCeh6i2rh8fopuf7Anof-DmE9cD7e-WqMN0hnngpYFcqv0Qklg
Message-ID: <CAH2r5mujUh+QGawx42hVwFSd1_JJKYMOpiqctprtzkqh8Oy_qA@mail.gmail.com>
Subject: Re: [PATCH 6/7] cifs: optimize readdir for larger directories
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

it also looks like it (this patch 6) has build warnings

  CHECK   smb2ops.c
smb2ops.c:5378:51: warning: restricted __le16 degrades to integer
smb2ops.c:5381:58: warning: restricted __le16 degrades to integer
smb2ops.c:5532:51: warning: restricted __le16 degrades to integer
smb2ops.c:5535:58: warning: restricted __le16 degrades to integer

On Wed, Apr 15, 2026 at 6:08=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> This (patch 6) hit a merge conflict with smb2ops.c when I tried to
> apply it to current cifs-2.6.git for-next for testing
>
> patching file fs/smb/client/smb2ops.c
> Hunk #6 FAILED at 5455.
> Hunk #7 succeeded at 5494 (offset 8 lines).
> Hunk #8 succeeded at 5508 (offset 8 lines).
> Hunk #9 succeeded at 5683 (offset 8 lines).
> 1 out of 9 hunks FAILED -- saving rejects to file fs/smb/client/smb2ops.c=
.rej
>
> On Tue, Apr 14, 2026 at 8:59=E2=80=AFAM <nspmangalore@gmail.com> wrote:
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
> > Cc: David Howells <dhowells@redhat.com>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsglob.h  |  23 +-
> >  fs/smb/client/cifsproto.h |   3 +
> >  fs/smb/client/readdir.c   |   2 +-
> >  fs/smb/client/smb1ops.c   |   4 +-
> >  fs/smb/client/smb2misc.c  |   7 +-
> >  fs/smb/client/smb2ops.c   | 452 ++++++++++++++++++++++++++++++++++++--
> >  fs/smb/client/smb2pdu.c   | 182 ++++++++++++++-
> >  fs/smb/client/smb2pdu.h   |   3 +
> >  fs/smb/client/smb2proto.h |   3 +
> >  fs/smb/client/trace.h     |   1 +
> >  fs/smb/client/transport.c | 184 ++++++++++++++++
> >  11 files changed, 829 insertions(+), 35 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index 8d089ba08e3e5..45de35ecc0bd2 100644
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
> > @@ -1397,6 +1397,27 @@ struct cifs_search_info {
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
> > +       struct kvec combined_iov;       /* Pre-allocated combined heade=
r+data buffer;
> > +                                        * iov_len holds total capacity=
 until the receive
> > +                                        * handler fills it in, then ac=
tual valid length */
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
> > index 5c6fe25204d26..ecbd717f5a5ea 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -2703,11 +2703,130 @@ smb2_query_dir_first(const unsigned int xid, s=
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
ismatch - not treating as end-of-search\n", __func__);
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
> > @@ -4824,6 +4943,247 @@ cifs_copy_folioq_to_iter(struct folio_queue *fo=
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
> > +               /* Copy header to persistent combined_iov buffer so sta=
tus
> > +                * remains accessible after receive handler returns. bu=
f is temporary
> > +                * and will be freed/reused, so we can't leave iov[0] p=
ointing to it. */
> > +               if (qd_io->combined_iov.iov_base && hdr_len > 0 &&
> > +                   hdr_len <=3D qd_io->combined_iov.iov_len) {
> > +                       memcpy(qd_io->combined_iov.iov_base, buf, hdr_l=
en);
> > +                       qd_io->iov[0].iov_base =3D qd_io->combined_iov.=
iov_base;
> > +                       qd_io->iov[0].iov_len =3D hdr_len;
> > +                       cifs_dbg(FYI, "%s: copied error response header=
 to combined_iov\n", __func__);
> > +               }
> > +
> > +               /* Normal error on query_directory response - response =
received successfully,
> > +                * but the command failed. Store error in qd_io->result=
 for callback. */
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
> > @@ -4987,25 +5347,46 @@ static void smb2_decrypt_offload(struct work_st=
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
> > @@ -5049,9 +5430,10 @@ receive_encrypted_read(struct TCP_Server_Info *s=
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
> > @@ -5062,7 +5444,10 @@ receive_encrypted_read(struct TCP_Server_Info *s=
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
> > @@ -5070,9 +5455,8 @@ receive_encrypted_read(struct TCP_Server_Info *se=
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
> > @@ -5101,7 +5485,7 @@ receive_encrypted_read(struct TCP_Server_Info *se=
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
> > @@ -5115,20 +5499,41 @@ receive_encrypted_read(struct TCP_Server_Info *=
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
> > @@ -5269,7 +5674,6 @@ smb3_receive_transform(struct TCP_Server_Info *se=
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
> > index 2d55246d2851b..b59d99d5e193a 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -5496,6 +5496,182 @@ num_entries(int infotype, char *bufstart, char =
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
> > +                       struct smb_rqst rqst =3D { .rq_iov =3D &qd_io->=
iov[0], .rq_nvec =3D 1 };
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
> > @@ -5560,12 +5736,6 @@ int SMB2_query_directory_init(const unsigned int=
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
> > index 05f8099047e1a..4457b98b9365d 100644
> > --- a/fs/smb/client/transport.c
> > +++ b/fs/smb/client/transport.c
> > @@ -1154,6 +1154,190 @@ cifs_readv_discard(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
> >         return  __cifs_readv_discard(server, mid, rdata->result);
> >  }
> >
> > +static int
> > +cifs_query_dir_discard(struct TCP_Server_Info *server, struct mid_q_en=
try *mid)
> > +{
> > +       int length;
> > +       struct cifs_query_dir_io *qd_io =3D mid->callback_data;
> > +
> > +       length =3D cifs_discard_remaining_data(server);
> > +       dequeue_mid(server, mid, qd_io->result !=3D 0);
> > +       mid->resp_buf =3D server->smallbuf;
> > +       server->smallbuf =3D NULL;
> > +       return length;
> > +}
> > +
> > +/*
> > + * Receive handler for async QueryDirectory with multi-credit support
> > + */
> > +int
> > +cifs_query_dir_receive(struct TCP_Server_Info *server, struct mid_q_en=
try *mid)
> > +{
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
> > +               goto discard_and_queue;
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
> > +               return cifs_query_dir_discard(server, mid);
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
> > +               return cifs_query_dir_discard(server, mid);
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
> > +               return cifs_query_dir_discard(server, mid);
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
> > +                       goto discard_and_queue;
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
> > +               return cifs_query_dir_discard(server, mid);
> > +       }
> > +
> > +       /*
> > +        * Build combined header+data in qd_io->combined_iov.iov_base.
> > +        * Layout: [header][data] with no padding between them.
> > +        * We update OutputBufferOffset in the header to reflect the ne=
w layout.
> > +        */
> > +       if (qd_io->iov[0].iov_len > 0 && qd_io->result =3D=3D 0) {
> > +               size_t hdr_len =3D qd_io->iov[0].iov_len;
> > +               struct smb2_query_directory_rsp *combined_rsp;
> > +
> > +               /* Copy header to beginning of combined buffer */
> > +               memcpy(qd_io->combined_iov.iov_base, qd_io->iov[0].iov_=
base, hdr_len);
> > +
> > +               /* Read directory entries directly after the header, re=
moving any padding */
> > +               if (data_len > 0) {
> > +                       length =3D cifs_read_from_socket(server,
> > +                                                      qd_io->combined_=
iov.iov_base + hdr_len,
> > +                                                      data_len);
> > +                       if (length < 0) {
> > +                               qd_io->result =3D length;
> > +                               goto discard_and_queue;
> > +                       }
> > +                       server->total_read +=3D length;
> > +
> > +                       /* Update OutputBufferOffset and OutputBufferLe=
ngth to reflect
> > +                        * the new compact layout (header followed imme=
diately by data).
> > +                        */
> > +                       combined_rsp =3D (struct smb2_query_directory_r=
sp *)qd_io->combined_iov.iov_base;
> > +                       combined_rsp->OutputBufferOffset =3D cpu_to_le1=
6(hdr_len);
> > +                       combined_rsp->OutputBufferLength =3D cpu_to_le3=
2(length);
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
> > +
> > +discard_and_queue:
> > +       /* Discard any remaining data (shouldn't be any) */
> > +       if (server->total_read < buflen)
> > +               cifs_discard_remaining_data(server);
> > +
> > +       dequeue_mid(server, mid, false);
> > +       mid->resp_buf =3D server->smallbuf;
> > +       server->smallbuf =3D NULL;
> > +       return length;
> > +}
> > +
> >  int
> >  cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry =
*mid)
> >  {
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
