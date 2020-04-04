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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB1FC43331
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Apr 2020 00:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3A9C20787
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Apr 2020 00:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eeBSdTHx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgDDAFD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Apr 2020 20:05:03 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37206 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgDDAFD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Apr 2020 20:05:03 -0400
Received: by mail-lf1-f68.google.com with SMTP id t11so7235380lfe.4;
        Fri, 03 Apr 2020 17:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5TVVdjtml6JXABon4unEArMGra7kJXacNjWILU9VOgc=;
        b=eeBSdTHxVvlrlWwR1il4ox3+YNTYTuKEz8ChUXXdJ9QO01OJiER/Ilj4rjlf6kh5eR
         GWR9aTXnS19ZwzEmgOFXVnR7KeheI03r7KczGIJICQz/i2Te0tflqiXaSt14JCZTcO48
         lctScDzzdcoS/IK3eEDCH9KtZko/sKqARtNhj1xaSamVsIS4ouiRkBjB2+0G2p/BuGQK
         r1XkcoNQaCg2r/zVMhnYcwSaFrHM4+pra14Yo5vAwrIFDRcah+756mwaEA4OvyUXNIwA
         8rv4H92TpXLFIungGUqFOAjc67Pue6jp/HNgVuirxNLEUxAPesrSvFaFdRSpwqqDqq4M
         9NtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5TVVdjtml6JXABon4unEArMGra7kJXacNjWILU9VOgc=;
        b=ObE4tiSAgBN7l3BlF5y/WDUN1vkxIKpQHOn4JwXcnIkkYbywCjFtZz9cvrTcN6wNw8
         sellEsr+yz1AG0O2ynZlW0av3ymZa4Gvr0GpF+tJjKTRatjnJUaY1ezb4zUUbeNdGCbW
         +giFDBIJxkZyQIgzYBc8Fky47m/LDdzuE47uuamnji7kd8GaGNyRCyBtMNIxizHSQrTz
         drlzmAttwWqAja+KgQSCN40+1EZ0ia3V4SIAm/9dl/bC4u04ihEjjNdeIFyfaIv5oWWW
         VLu2FFrMQu2wA04aXKbP5ksofGScXTxYZkNTZZLcFpfw0OtoWqLHfWRQgp1itfise7IT
         4g3w==
X-Gm-Message-State: AGi0PubnCCEWiYk4WkVnnrvhD2yX3YG0Bc1fQkD259NSo8/ixbdwmVb2
        NTEJbTeBVsMxWUP6QnO+CvvqXi/0MPmehTNzHA==
X-Google-Smtp-Source: APiQypJZjzkMlOLYGeKDvfA8A+NrC/WyIP5a930kImq35w+pFFHBlpZDxqgaTcuW8L38FQYwLGnqFZUM2dLexYuIGG8=
X-Received: by 2002:a19:4843:: with SMTP id v64mr6664943lfa.171.1585958699614;
 Fri, 03 Apr 2020 17:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <1585696903-96794-1-git-send-email-longli@linuxonhyperv.com>
 <CAKywueRg8kJ+0aOehM-QKGuRwbDSb2TA5vNje8eSCdMqBT+EdQ@mail.gmail.com> <BN8PR21MB11559BF18DF932A38624369ECEC70@BN8PR21MB1155.namprd21.prod.outlook.com>
In-Reply-To: <BN8PR21MB11559BF18DF932A38624369ECEC70@BN8PR21MB1155.namprd21.prod.outlook.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 3 Apr 2020 17:04:48 -0700
Message-ID: <CAKywueRBghVuNtfP0XdLYL-wS_Nfci8uF_7pRPSjvQDif22BFQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Allocate crypto structures on the fly for
 calculating signatures of incoming packets
To:     Long Li <longli@microsoft.com>
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

=D0=BF=D1=82, 3 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 16:11, Long Li <lon=
gli@microsoft.com>:
>
> >Subject: Re: [PATCH] cifs: Allocate crypto structures on the fly for cal=
culating
> >signatures of incoming packets
> >
> >=D0=B2=D1=82, 31 =D0=BC=D0=B0=D1=80. 2020 =D0=B3. =D0=B2 16:22, <longli@=
linuxonhyperv.com>:
> >>
> >> From: Long Li <longli@microsoft.com>
> >>
> >> CIFS uses pre-allocated crypto structures to calculate signatures for
> >> both incoming and outgoing packets. In this way it doesn't need to
> >> allocate crypto structures for every packet, but it requires a lock to
> >> prevent concurrent access to crypto structures.
> >>
> >> Remove the lock by allocating crypto structures on the fly for
> >> incoming packets. At the same time, we can still use pre-allocated
> >> crypto structures for outgoing packets, as they are already protected
> >> by transport lock srv_mutex.
> >>
> >> Signed-off-by: Long Li <longli@microsoft.com>
> >> ---
> >>  fs/cifs/cifsglob.h      |  3 +-
> >>  fs/cifs/smb2proto.h     |  6 ++-
> >>  fs/cifs/smb2transport.c | 87
> >> +++++++++++++++++++++++++----------------
> >>  3 files changed, 60 insertions(+), 36 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h index
> >> 0d956360e984..7448e7202e7a 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -426,7 +426,8 @@ struct smb_version_operations {
> >>         /* generate new lease key */
> >>         void (*new_lease_key)(struct cifs_fid *);
> >>         int (*generate_signingkey)(struct cifs_ses *);
> >> -       int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Inf=
o *);
> >> +       int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Inf=
o *,
> >> +                               bool allocate_crypto);
> >>         int (*set_integrity)(const unsigned int, struct cifs_tcon *tco=
n,
> >>                              struct cifsFileInfo *src_file);
> >>         int (*enum_snapshots)(const unsigned int xid, struct cifs_tcon
> >> *tcon, diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h index
> >> 4d1ff7b66fdc..087d5f14320b 100644
> >> --- a/fs/cifs/smb2proto.h
> >> +++ b/fs/cifs/smb2proto.h
> >> @@ -55,9 +55,11 @@ extern struct cifs_ses *smb2_find_smb_ses(struct
> >> TCP_Server_Info *server,  extern struct cifs_tcon
> >*smb2_find_smb_tcon(struct TCP_Server_Info *server,
> >>                                                 __u64 ses_id, __u32
> >> tid);  extern int smb2_calc_signature(struct smb_rqst *rqst,
> >> -                               struct TCP_Server_Info *server);
> >> +                               struct TCP_Server_Info *server,
> >> +                               bool allocate_crypto);
> >>  extern int smb3_calc_signature(struct smb_rqst *rqst,
> >> -                               struct TCP_Server_Info *server);
> >> +                               struct TCP_Server_Info *server,
> >> +                               bool allocate_crypto);
> >>  extern void smb2_echo_request(struct work_struct *work);  extern
> >> __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);  extern
> >> bool smb2_is_valid_oplock_break(char *buffer, diff --git
> >> a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c index
> >> 08b703b7a15e..c01e19a3b112 100644
> >> --- a/fs/cifs/smb2transport.c
> >> +++ b/fs/cifs/smb2transport.c
> >> @@ -40,14 +40,6 @@
> >>  #include "smb2status.h"
> >>  #include "smb2glob.h"
> >>
> >> -static int
> >> -smb2_crypto_shash_allocate(struct TCP_Server_Info *server) -{
> >> -       return cifs_alloc_hash("hmac(sha256)",
> >> -                              &server->secmech.hmacsha256,
> >> -                              &server->secmech.sdeschmacsha256);
> >> -}
> >> -
> >>  static int
> >>  smb3_crypto_shash_allocate(struct TCP_Server_Info *server)  { @@
> >> -219,7 +211,8 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server,
> >> __u64 ses_id, __u32  tid)  }
> >>
> >>  int
> >> -smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info
> >> *server)
> >> +smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info
> >*server,
> >> +                       bool allocate_crypto)
> >>  {
> >>         int rc;
> >>         unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
> >> @@ -228,6 +221,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
> >TCP_Server_Info *server)
> >>         struct smb2_sync_hdr *shdr =3D (struct smb2_sync_hdr *)iov[0].=
iov_base;
> >>         struct cifs_ses *ses;
> >>         struct shash_desc *shash;
> >> +       struct crypto_shash *hash;
> >> +       struct sdesc *sdesc =3D NULL;
> >>         struct smb_rqst drqst;
> >>
> >>         ses =3D smb2_find_smb_ses(server, shdr->SessionId); @@ -239,24
> >> +234,32 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
> >TCP_Server_Info *server)
> >>         memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
> >>         memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
> >>
> >> -       rc =3D smb2_crypto_shash_allocate(server);
> >> -       if (rc) {
> >> -               cifs_server_dbg(VFS, "%s: sha256 alloc failed\n", __fu=
nc__);
> >> -               return rc;
> >> +       if (allocate_crypto) {
> >> +               rc =3D cifs_alloc_hash("hmac(sha256)", &hash, &sdesc);
> >> +               if (rc) {
> >> +                       cifs_server_dbg(VFS,
> >> +                                       "%s: sha256 alloc failed\n", _=
_func__);
> >> +                       return rc;
> >> +               }
> >> +               shash =3D &sdesc->shash;
> >> +       } else {
> >> +               hash =3D server->secmech.hmacsha256;
> >> +               shash =3D &server->secmech.sdeschmacsha256->shash;
> >>         }
> >
> >smb2_crypto_shash_allocate() unconditionally allocated
> >server->secmech.hmacsha256 and server->secmech.sdeschmacsha256-
> >>shash.
>
> I think they are allocated in smb311_crypto_shash_allocate(), through
> =3D> smb311_crypto_shash_allocate
>  =3D> smb311_update_preauth_hash
>  =3D> compound_send_recv
>  =3D> cifs_send_recv
>  =3D> SMB2_negotiate
>
> The function names are a little misleading...

smb311_crypto_shash_allocate() only allocate those structures for SMB
3.1.1 protocol version, see the code below:

797 int
798 smb311_update_preauth_hash(struct cifs_ses *ses, struct kvec *iov, int =
nvec)
799 {
800 >-------int i, rc;
801 >-------struct sdesc *d;
802 >-------struct smb2_sync_hdr *hdr;
803
804 >-------if (ses->server->tcpStatus =3D=3D CifsGood) {
805 >------->-------/* skip non smb311 connections */
806 >------->-------if (ses->server->dialect !=3D SMB311_PROT_ID)
807 >------->------->-------return 0;

--
Best regards,
Pavel Shilovsky
