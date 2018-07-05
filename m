From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] cifs: Fix slab-out-of-bounds in send_set_info() on SMB2
 ACE setting
Date: Thu, 5 Jul 2018 18:00:38 +0200
Message-ID: <20180705180039.51700198@epycfail>
References: <af471807b329692a387ff26e62e1bbca01e1684f.1530783326.git.sbrivio@redhat.com>
        <87d0w17nu3.fsf@suse.com>
        <CAH2r5muhkbO45en38894ZzpcMshUJsp7r1X5P9jwizjce7LzuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>, jiyin@redhat.com,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Stable <stable@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muhkbO45en38894ZzpcMshUJsp7r1X5P9jwizjce7LzuQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 5 Jul 2018 09:55:49 -0500
Steve French <smfrench@gmail.com> wrote:

> On Thu, Jul 5, 2018 at 9:35 AM Aurélien Aptel <aaptel@suse.com> wrote:
> >
> > Stefano Brivio <sbrivio@redhat.com> writes:  
> > >       /* BB eventually switch this to SMB2 specific small buf size */
> > > -     *request_buf = cifs_small_buf_get();
> > > +     if (smb2_command == SMB2_SET_INFO)
> > > +             *request_buf = cifs_buf_get();
> > > +     else
> > > +             *request_buf = cifs_small_buf_get();
> > >       if (*request_buf == NULL) {
> > >               /* BB should we add a retry in here if not a writepage? */
> > >               return -ENOMEM;
> > > @@ -3720,7 +3723,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
> > >
> > >       rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
> > >                           &rsp_iov);
> > > -     cifs_small_buf_release(req);
> > > +     cifs_buf_release(req);
> > >       rsp = (struct smb2_set_info_rsp *)rsp_iov.iov_base;  
> >
> > Small and large bufs use different mempools, shouldn't the release func
> > match the get func?  
> 
> Yes
> 
> Stefano,
> Can you respin your patch?  I am hoping this patch addresses a bug I
> have been seeing

Steve,

I guess I'm missing something, but I fail to see the mismatch between
get and release, now for SMB2_SET_INFO we'll be using cifs_req_poolp in
both paths. What should I change?

-- 
Stefano
