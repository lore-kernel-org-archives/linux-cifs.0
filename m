Return-Path: <SRS0=eyz5=5U=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4670AC43331
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Apr 2020 00:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E56720787
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Apr 2020 00:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mz76Jtw2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgDDAQp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Apr 2020 20:16:45 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44204 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgDDAQp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Apr 2020 20:16:45 -0400
Received: by mail-lj1-f196.google.com with SMTP id p14so8733926lji.11;
        Fri, 03 Apr 2020 17:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J8n05cXVDxLDMg92Ho2uP4treDpdMhCY7PTyp+b4thA=;
        b=Mz76Jtw2q6rbszJF4gedKuANhRIzASUU9teAv/mgDoVc4CBj6+Fn5MLEHO/spOl0OI
         +M1JF579uQ3JDlmyzagVHbjMhVmSHcCha5FRTDEEfzdE65G+xeotEBk9Vp+poVcPQJwm
         a8ND6ZKKIy8kT7H/JdgEz85Wx/Y6uzMOk557PV1ZZcS2158joCqlFGdS7e5E8zr6NvH5
         x3QJ9XuebOpbMMcsEdgdgAGo6bO6iUkALjfI9cljKG0fSPF831IOagkADFqVAA15EtFX
         qhfC3YJBNpI23ouMU2CD3CNoJURHp/GX50Gkm4u2cgdS4zbYsE17Y5HNRiEBE4dbkjJm
         dd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J8n05cXVDxLDMg92Ho2uP4treDpdMhCY7PTyp+b4thA=;
        b=gEcFwLfvv8IwkvlG/1AiRtB9ujEZXG8DMqXKnUg05QogVDjBcbsq88P1OqkKtXVGh+
         asaez4hY4yccGos0qIt6rXUzkSaRhNL33lWhqrRQePGdWjPTa2R7mC2b2RdAGK5yXvvS
         QYc/w3xooFqLEMZt5ceuCgCDTPAe0yl5fQlP1lmSOo3Hc0XZFxXbXkouL2MGb+EAV+Uo
         AsnKHvdZ5lwRt7EcTe9O+Luw/U8QuLlS6UccgUemDhVJkniQqyVBA1yv6ObKsL0Caqh+
         QE6hsA63ti2hHlj37BZtFign/3egKRazsGCGf2eTF0309KtjlduK4jgFLwAANUL4oG5X
         DVZw==
X-Gm-Message-State: AGi0PuatbJm5x1i7R5o/tZvpymhIB/qm3J/Yo/ybbbQaJD465pX5a5sV
        yH794oUgZB7EmzdQCCGPRu5lSt484lcCVPpJ0g==
X-Google-Smtp-Source: APiQypI8BgVJzsiiaJt9ibXDsej3HhZtcy+pdJbw9dhS2ryLRbnoOlSKikfbBoIjwOwShXG3JT9rHcOAL0oz4+Lk/9s=
X-Received: by 2002:a2e:3c0b:: with SMTP id j11mr6423552lja.9.1585959401499;
 Fri, 03 Apr 2020 17:16:41 -0700 (PDT)
MIME-Version: 1.0
References: <1585696903-96794-1-git-send-email-longli@linuxonhyperv.com>
 <CAKywueRg8kJ+0aOehM-QKGuRwbDSb2TA5vNje8eSCdMqBT+EdQ@mail.gmail.com>
 <BN8PR21MB11559BF18DF932A38624369ECEC70@BN8PR21MB1155.namprd21.prod.outlook.com>
 <CAKywueRBghVuNtfP0XdLYL-wS_Nfci8uF_7pRPSjvQDif22BFQ@mail.gmail.com>
In-Reply-To: <CAKywueRBghVuNtfP0XdLYL-wS_Nfci8uF_7pRPSjvQDif22BFQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 3 Apr 2020 17:16:30 -0700
Message-ID: <CAKywueTyHNw5P1M4WR+SdBKU-yXvJEfJc5VSONveNBZm-dOjKQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Allocate crypto structures on the fly for
 calculating signatures of incoming packets
To:     Long Li <longli@microsoft.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 3 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 17:04, Pavel Shilov=
sky <piastryyy@gmail.com>:
>
> =D0=BF=D1=82, 3 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 16:11, Long Li <l=
ongli@microsoft.com>:
> >
> > >Subject: Re: [PATCH] cifs: Allocate crypto structures on the fly for c=
alculating
> > >signatures of incoming packets
> > >
> > >=D0=B2=D1=82, 31 =D0=BC=D0=B0=D1=80. 2020 =D0=B3. =D0=B2 16:22, <longl=
i@linuxonhyperv.com>:
> > >>
> > >> From: Long Li <longli@microsoft.com>
> > >>
> > >> CIFS uses pre-allocated crypto structures to calculate signatures fo=
r
> > >> both incoming and outgoing packets. In this way it doesn't need to
> > >> allocate crypto structures for every packet, but it requires a lock =
to
> > >> prevent concurrent access to crypto structures.
> > >>
> > >> Remove the lock by allocating crypto structures on the fly for
> > >> incoming packets. At the same time, we can still use pre-allocated
> > >> crypto structures for outgoing packets, as they are already protecte=
d
> > >> by transport lock srv_mutex.
> > >>
> > >> Signed-off-by: Long Li <longli@microsoft.com>
> > >> ---
> > >>  fs/cifs/cifsglob.h      |  3 +-
> > >>  fs/cifs/smb2proto.h     |  6 ++-
> > >>  fs/cifs/smb2transport.c | 87
> > >> +++++++++++++++++++++++++----------------
> > >>  3 files changed, 60 insertions(+), 36 deletions(-)
> > >>
> > >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h index
> > >> 0d956360e984..7448e7202e7a 100644
> > >> --- a/fs/cifs/cifsglob.h
> > >> +++ b/fs/cifs/cifsglob.h
> > >> @@ -426,7 +426,8 @@ struct smb_version_operations {
> > >>         /* generate new lease key */
> > >>         void (*new_lease_key)(struct cifs_fid *);
> > >>         int (*generate_signingkey)(struct cifs_ses *);
> > >> -       int (*calc_signature)(struct smb_rqst *, struct TCP_Server_I=
nfo *);
> > >> +       int (*calc_signature)(struct smb_rqst *, struct TCP_Server_I=
nfo *,
> > >> +                               bool allocate_crypto);
> > >>         int (*set_integrity)(const unsigned int, struct cifs_tcon *t=
con,
> > >>                              struct cifsFileInfo *src_file);
> > >>         int (*enum_snapshots)(const unsigned int xid, struct cifs_tc=
on
> > >> *tcon, diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h index
> > >> 4d1ff7b66fdc..087d5f14320b 100644
> > >> --- a/fs/cifs/smb2proto.h
> > >> +++ b/fs/cifs/smb2proto.h
> > >> @@ -55,9 +55,11 @@ extern struct cifs_ses *smb2_find_smb_ses(struct
> > >> TCP_Server_Info *server,  extern struct cifs_tcon
> > >*smb2_find_smb_tcon(struct TCP_Server_Info *server,
> > >>                                                 __u64 ses_id, __u32
> > >> tid);  extern int smb2_calc_signature(struct smb_rqst *rqst,
> > >> -                               struct TCP_Server_Info *server);
> > >> +                               struct TCP_Server_Info *server,
> > >> +                               bool allocate_crypto);
> > >>  extern int smb3_calc_signature(struct smb_rqst *rqst,
> > >> -                               struct TCP_Server_Info *server);
> > >> +                               struct TCP_Server_Info *server,
> > >> +                               bool allocate_crypto);
> > >>  extern void smb2_echo_request(struct work_struct *work);  extern
> > >> __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);  extern
> > >> bool smb2_is_valid_oplock_break(char *buffer, diff --git
> > >> a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c index
> > >> 08b703b7a15e..c01e19a3b112 100644
> > >> --- a/fs/cifs/smb2transport.c
> > >> +++ b/fs/cifs/smb2transport.c
> > >> @@ -40,14 +40,6 @@
> > >>  #include "smb2status.h"
> > >>  #include "smb2glob.h"
> > >>
> > >> -static int
> > >> -smb2_crypto_shash_allocate(struct TCP_Server_Info *server) -{
> > >> -       return cifs_alloc_hash("hmac(sha256)",
> > >> -                              &server->secmech.hmacsha256,
> > >> -                              &server->secmech.sdeschmacsha256);
> > >> -}
> > >> -
> > >>  static int
> > >>  smb3_crypto_shash_allocate(struct TCP_Server_Info *server)  { @@
> > >> -219,7 +211,8 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server,
> > >> __u64 ses_id, __u32  tid)  }
> > >>
> > >>  int
> > >> -smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info
> > >> *server)
> > >> +smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info
> > >*server,
> > >> +                       bool allocate_crypto)
> > >>  {
> > >>         int rc;
> > >>         unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
> > >> @@ -228,6 +221,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struc=
t
> > >TCP_Server_Info *server)
> > >>         struct smb2_sync_hdr *shdr =3D (struct smb2_sync_hdr *)iov[0=
].iov_base;
> > >>         struct cifs_ses *ses;
> > >>         struct shash_desc *shash;
> > >> +       struct crypto_shash *hash;
> > >> +       struct sdesc *sdesc =3D NULL;
> > >>         struct smb_rqst drqst;
> > >>
> > >>         ses =3D smb2_find_smb_ses(server, shdr->SessionId); @@ -239,=
24
> > >> +234,32 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
> > >TCP_Server_Info *server)
> > >>         memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
> > >>         memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
> > >>
> > >> -       rc =3D smb2_crypto_shash_allocate(server);
> > >> -       if (rc) {
> > >> -               cifs_server_dbg(VFS, "%s: sha256 alloc failed\n", __=
func__);
> > >> -               return rc;
> > >> +       if (allocate_crypto) {
> > >> +               rc =3D cifs_alloc_hash("hmac(sha256)", &hash, &sdesc=
);
> > >> +               if (rc) {
> > >> +                       cifs_server_dbg(VFS,
> > >> +                                       "%s: sha256 alloc failed\n",=
 __func__);
> > >> +                       return rc;
> > >> +               }
> > >> +               shash =3D &sdesc->shash;
> > >> +       } else {
> > >> +               hash =3D server->secmech.hmacsha256;
> > >> +               shash =3D &server->secmech.sdeschmacsha256->shash;
> > >>         }
> > >
> > >smb2_crypto_shash_allocate() unconditionally allocated
> > >server->secmech.hmacsha256 and server->secmech.sdeschmacsha256-
> > >>shash.
> >
> > I think they are allocated in smb311_crypto_shash_allocate(), through
> > =3D> smb311_crypto_shash_allocate
> >  =3D> smb311_update_preauth_hash
> >  =3D> compound_send_recv
> >  =3D> cifs_send_recv
> >  =3D> SMB2_negotiate
> >
> > The function names are a little misleading...
>
> smb311_crypto_shash_allocate() only allocate those structures for SMB
> 3.1.1 protocol version, see the code below:
>
> 797 int
> 798 smb311_update_preauth_hash(struct cifs_ses *ses, struct kvec *iov, in=
t nvec)
> 799 {
> 800 >-------int i, rc;
> 801 >-------struct sdesc *d;
> 802 >-------struct smb2_sync_hdr *hdr;
> 803
> 804 >-------if (ses->server->tcpStatus =3D=3D CifsGood) {
> 805 >------->-------/* skip non smb311 connections */
> 806 >------->-------if (ses->server->dialect !=3D SMB311_PROT_ID)
> 807 >------->------->-------return 0;
>

+ Aurelien

Ok, before negotiate tcpStatus is not CifsGood, so, the allocation
won't be skipped. I think this function should be no-op for all
protocols except SMB 3.1.1 to reflect the meaning. Other protocols
don't use preauth hash anyway.

@Aurelien, @everybody, what would be your thoughts about moving
protocol version check from IF block to the top of the function thus
skipping to allocate preauth hash for protocols that don't need it? In
this case Long's patch will require a change to keep
smb2_crypto_shash_allocate() and its invocation.

--
Best regards,
Pavel Shilovsky
