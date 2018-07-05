From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
Subject: Re: [PATCH] cifs: Fix slab-out-of-bounds in send_set_info() on SMB2 ACE setting
Date: Thu, 05 Jul 2018 19:11:48 +0200
Message-ID: <874lhd7gkr.fsf@suse.com>
References: <af471807b329692a387ff26e62e1bbca01e1684f.1530783326.git.sbrivio@redhat.com> <87d0w17nu3.fsf@suse.com> <CAH2r5muhkbO45en38894ZzpcMshUJsp7r1X5P9jwizjce7LzuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: sbrivio@redhat.com, Steve French <sfrench@samba.org>,
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

Steve French <smfrench@gmail.com> writes:
> On Thu, Jul 5, 2018 at 9:35 AM Aurélien Aptel <aaptel@suse.com> wrote:
>>
>> Stefano Brivio <sbrivio@redhat.com> writes:
>> >       /* BB eventually switch this to SMB2 specific small buf size */
>> > -     *request_buf = cifs_small_buf_get();
>> > +     if (smb2_command == SMB2_SET_INFO)
>> > +             *request_buf = cifs_buf_get();
>> > +     else
>> > +             *request_buf = cifs_small_buf_get();
>> >       if (*request_buf == NULL) {
>> >               /* BB should we add a retry in here if not a writepage? */
>> >               return -ENOMEM;
>> > @@ -3720,7 +3723,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
>> >
>> >       rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
>> >                           &rsp_iov);
>> > -     cifs_small_buf_release(req);
>> > +     cifs_buf_release(req);
>> >       rsp = (struct smb2_set_info_rsp *)rsp_iov.iov_base;
>>
>> Small and large bufs use different mempools, shouldn't the release func
>> match the get func?
>
> Yes
>
> Stefano,
> Can you respin your patch?  I am hoping this patch addresses a bug I
> have been seeing

I've ran xfstests with the 2 patches on top (smb3 section only again) I
get good results less failures than v4.17 :)

Failures: generic/112 generic/123 generic/128 generic/210 generic/323 generic/355 generic/378 generic/469 generic/478 generic/484 generic/486
Failed 11 of 394 tests


Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
