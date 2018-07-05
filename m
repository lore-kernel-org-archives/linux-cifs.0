From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: Fix slab-out-of-bounds in send_set_info() on SMB2
 ACE setting
Date: Thu, 5 Jul 2018 12:53:23 -0500
Message-ID: <CAH2r5mtLPyM5GvMKauNcCLUZzfnDJuL9k_xzt5ePdtsCdmOmyg@mail.gmail.com>
References: <af471807b329692a387ff26e62e1bbca01e1684f.1530783326.git.sbrivio@redhat.com>
 <87d0w17nu3.fsf@suse.com> <20180705165858.7679fc44@epycfail>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>, jiyin@redhat.com,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Stable <stable@vger.kernel.org>
To: sbrivio@redhat.com
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180705165858.7679fc44@epycfail>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Reviewed the patch in more detail - and it looks correct am merging
this and the other fixes for cc:stable today into cifs-2.6.git
for-next

Thanks for spotting this.


On Thu, Jul 5, 2018 at 9:59 AM Stefano Brivio <sbrivio@redhat.com> wrote:
>
> On Thu, 05 Jul 2018 16:35:00 +0200
> Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> > Stefano Brivio <sbrivio@redhat.com> writes:
> > >     /* BB eventually switch this to SMB2 specific small buf size */
> > > -   *request_buf =3D cifs_small_buf_get();
> > > +   if (smb2_command =3D=3D SMB2_SET_INFO)
> > > +           *request_buf =3D cifs_buf_get();
> > > +   else
> > > +           *request_buf =3D cifs_small_buf_get();
> > >     if (*request_buf =3D=3D NULL) {
> > >             /* BB should we add a retry in here if not a writepage? *=
/
> > >             return -ENOMEM;
> > > @@ -3720,7 +3723,7 @@ send_set_info(const unsigned int xid, struct ci=
fs_tcon *tcon,
> > >
> > >     rc =3D cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
> > >                         &rsp_iov);
> > > -   cifs_small_buf_release(req);
> > > +   cifs_buf_release(req);
> > >     rsp =3D (struct smb2_set_info_rsp *)rsp_iov.iov_base;
> >
> > Small and large bufs use different mempools, shouldn't the release func
> > match the get func?
>
> I think it does: for SMB2_SET_INFO we'll allocate with cifs_buf_get(),
> which does:
>
>         ret_buf =3D mempool_alloc(cifs_req_poolp, GFP_NOFS);
>
> and release with cifs_buf_release():
>
>         mempool_free(buf_to_free, cifs_req_poolp);
>
> am I missing something?
>
> --
> Stefano
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
