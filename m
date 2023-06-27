Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23573EB64DC
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 06:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjF0GzC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 02:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjF0Gyh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 02:54:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B24C2969
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 23:54:18 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4fb8574a3a1so460523e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 23:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687848856; x=1690440856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9rjJ2RrqkIePxkoxDRUZuJ9chAuhhvMXXBhczaf9rEc=;
        b=TqQlif2pXAbGl1Tu8IFfrr4kKU1dNqJRBja8SROViHIB7rO5HVYwveeXtqnPeAilEj
         +WBo3H+cH8KZqGkeprGzEf/mmkgtUFErcn1Jqpu4m0bt7jyQlvTL01nXZEXgzBa/wOTf
         34Bcftr4ssi/XcbyIgLtAjo8XDFVLech8lqXEAJG0iC1G0BDMQUNK4/rMG6OHfaYigUY
         k5yIH8EFbjgdGq4J9fsPa7snAClZyIzEGZj7oFo4p6E3RF0jsob/0+ahHJ6uExG3JtVZ
         CiYplZJF9XMs9fqGCKnMuS4T+Gt9hlvxJdetq3C22VoYB9JoNhGUeOfWrYQVzmtYhp91
         iUWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687848856; x=1690440856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9rjJ2RrqkIePxkoxDRUZuJ9chAuhhvMXXBhczaf9rEc=;
        b=VUvQhFXT8R/fi3O6TRQUvDrVM5NlcyN32PU+P5FjyqQe/JWshr7WapDDyNHb7tdOlZ
         kANJ2xW6yc7eopyElT0ydEuUYaaHkzIZTpKZ3inonfEZcUZdYocdY6ynLzvfagjc3727
         wCSTWFm6xiLp8yB9E6sCjZZ886Swg6hl77G0nvweF64LbLN6YczCqqoCJYN3vycZrofH
         yCyWI2u9yiloH8f6csNMv/rdkyn0Hp/ZtdS47v9mmW5VTiONjEYZNpDF72/AO0LIZMV0
         7oIswocuPSnrm6OtGeFfpk/uZD0BOJNbiQ4oPPCaXTXh349RBWeLjMhwkVweTdU79iLt
         sSyg==
X-Gm-Message-State: AC+VfDxqWswzTTFKa+ORYTLdh2sX9DesUpm1ScTgkjPT7TATaahBHp/w
        QbsZopsO96UTDtNUJN2apnwfBuHznxvu4IqA5GOxkyqAQp9loQ==
X-Google-Smtp-Source: ACHHUZ6OjBDDtZTf556ok3LA9aAT32cTbe4zVsZBWAI7DOt8Q4BTZHFCO2uZpf7Sc01YIdiGnxJizKcHkmqY1hRfDSE=
X-Received: by 2002:a05:6512:3f24:b0:4fa:d522:a38e with SMTP id
 y36-20020a0565123f2400b004fad522a38emr4371113lfa.35.1687848855838; Mon, 26
 Jun 2023 23:54:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com>
 <20230626034257.2078391-2-wentao@uniontech.com> <CANT5p=pD+s8h33rgyjLHkJhz-OkAt3PMP5Oz612Qm3GO-PE2EQ@mail.gmail.com>
 <CAH2r5mtE8EmEPdxHc+AT256-ekzH1wjmTO+DbODHx+5PEYC9eA@mail.gmail.com>
 <CANT5p=oETR0vg29rGohLXoeqw0Lrrt8GsLbhjV6snLth7od=Nw@mail.gmail.com> <5C32A54005DEE4A2+20230626163909.1bd13a8a@winn-pc>
In-Reply-To: <5C32A54005DEE4A2+20230626163909.1bd13a8a@winn-pc>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 27 Jun 2023 12:24:04 +0530
Message-ID: <CANT5p=otyXgTf+UO1e2TQFUFbrhEwoV=xe861tJUWNiErUBG_g@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: fix session state transition to avoid
 use-after-free issue
To:     Winston Wen <wentao@uniontech.com>
Cc:     Steve French <smfrench@gmail.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, pc@manguebit.com, sprasad@microsoft.com
Content-Type: multipart/mixed; boundary="0000000000007cc2a705ff16ef9a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007cc2a705ff16ef9a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 26, 2023 at 2:09=E2=80=AFPM Winston Wen <wentao@uniontech.com> =
wrote:
>
> On Mon, 26 Jun 2023 12:24:35 +0530
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> > On Mon, Jun 26, 2023 at 10:54=E2=80=AFAM Steve French <smfrench@gmail.c=
om>
> > wrote:
> > >
> > > Added Cc: stable and Shyam's RB and merged into cifs-2.6.git
> > > for-next
> > >
> > > On Mon, Jun 26, 2023 at 12:15=E2=80=AFAM Shyam Prasad N
> > > <nspmangalore@gmail.com> wrote:
> > > >
> > > > On Mon, Jun 26, 2023 at 9:25=E2=80=AFAM Winston Wen
> > > > <wentao@uniontech.com> wrote:
> > > > >
> > > > > We switch session state to SES_EXITING without
> > > > > cifs_tcp_ses_lock now, it may lead to potential use-after-free
> > > > > issue.
> > > > >
> > > > > Consider the following execution processes:
> > > > >
> > > > > Thread 1:
> > > > > __cifs_put_smb_ses()
> > > > >     spin_lock(&cifs_tcp_ses_lock)
> > > > >     if (--ses->ses_count > 0)
> > > > >         spin_unlock(&cifs_tcp_ses_lock)
> > > > >         return
> > > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > > >         ---> **GAP**
> > > > >     spin_lock(&ses->ses_lock)
> > > > >     if (ses->ses_status =3D=3D SES_GOOD)
> > > > >         ses->ses_status =3D SES_EXITING
> > > > >     spin_unlock(&ses->ses_lock)
> > > > >
> > > > > Thread 2:
> > > > > cifs_find_smb_ses()
> > > > >     spin_lock(&cifs_tcp_ses_lock)
> > > > >     list_for_each_entry(ses, ...)
> > > > >         spin_lock(&ses->ses_lock)
> > > > >         if (ses->ses_status =3D=3D SES_EXITING)
> > > > >             spin_unlock(&ses->ses_lock)
> > > > >             continue
> > > > >         ...
> > > > >         spin_unlock(&ses->ses_lock)
> > > > >     if (ret)
> > > > >         cifs_smb_ses_inc_refcount(ret)
> > > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > > >
> > > > > If thread 1 is preempted in the gap and thread 2 start
> > > > > executing, thread 2 will get the session, and soon thread 1
> > > > > will switch the session state to SES_EXITING and start
> > > > > releasing it, even though thread 1 had increased the session's
> > > > > refcount and still uses it.
> > > > >
> > > > > So switch session state under cifs_tcp_ses_lock to eliminate
> > > > > this gap.
> > > > >
> > > > > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > > > > ---
> > > > >  fs/smb/client/connect.c | 7 ++++---
> > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > > > > index 9d16626e7a66..165ecb222c19 100644
> > > > > --- a/fs/smb/client/connect.c
> > > > > +++ b/fs/smb/client/connect.c
> > > > > @@ -1963,15 +1963,16 @@ void __cifs_put_smb_ses(struct cifs_ses
> > > > > *ses) spin_unlock(&cifs_tcp_ses_lock);
> > > > >                 return;
> > > > >         }
> > > > > +       spin_lock(&ses->ses_lock);
> > > > > +       if (ses->ses_status =3D=3D SES_GOOD)
> > > > > +               ses->ses_status =3D SES_EXITING;
> > > > > +       spin_unlock(&ses->ses_lock);
> > > > >         spin_unlock(&cifs_tcp_ses_lock);
> > > > >
> > > > >         /* ses_count can never go negative */
> > > > >         WARN_ON(ses->ses_count < 0);
> > > > >
> > > > >         spin_lock(&ses->ses_lock);
> > > > > -       if (ses->ses_status =3D=3D SES_GOOD)
> > > > > -               ses->ses_status =3D SES_EXITING;
> > > > > -
> > > > >         if (ses->ses_status =3D=3D SES_EXITING &&
> > > > > server->ops->logoff) { spin_unlock(&ses->ses_lock);
> > > > >                 cifs_free_ipc(ses);
> > > > > --
> > > > > 2.40.1
> > > > >
> > > >
> > > > Good catch.
> > > > Looks good to me.
> > > > @Steve French Please CC stable for this one.
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> > @Winston Wen I think the following change should be sufficient to fix
> > this issue:
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 9d16626e7a66..78874eb2537d 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -1963,10 +1963,11 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> >                 spin_unlock(&cifs_tcp_ses_lock);
> >                 return;
> >         }
> > -       spin_unlock(&cifs_tcp_ses_lock);
> >
> >         /* ses_count can never go negative */
> >         WARN_ON(ses->ses_count < 0);
> > +       list_del_init(&ses->smb_ses_list);
> > +       spin_unlock(&cifs_tcp_ses_lock);
> >
> >         spin_lock(&ses->ses_lock);
> >         if (ses->ses_status =3D=3D SES_GOOD)
> > @@ -1986,9 +1987,6 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> >                 cifs_free_ipc(ses);
> >         }
> >
> > -       spin_lock(&cifs_tcp_ses_lock);
> > -       list_del_init(&ses->smb_ses_list);
> > -       spin_unlock(&cifs_tcp_ses_lock);
> >
> >         chan_count =3D ses->chan_count;
> >
> > The bug was that the ses was kept in the smb ses list, even after the
> > ref count had reached 0.
> > With the above change, that should be fixed, and no one should be able
> > to get to the ses from that point.
> >
> > Please let me know if you see a problem with this.
> >
>
> Hi Shyam,
>
> Thanks for the comments! And sorry for my late reply...
>
> It make sense to me that maybe we should remove the session from the
> list once its refcount is reduced to 0 to avoid any futher access. In
> fact, I did try to do this from the beginning. But I was not sure if we
> need to access the session from the list in the free process, such
> as the following:
>
> smb2_check_receive()
>   smb2_verify_signature()
>     server->ops->calc_signature()
>       smb2_calc_signature()
>         smb2_find_smb_ses()
>           /* scan the list and find the session */
>
> Perhaps we need some refactoring here.

Yes. The above ses finding is expected to fail during a reconnect.

>
> So I gave up on this approach and did a small fix to make it work, but
> maybe I missed something elsewhere...
>
>
> --
> Thanks,
> Winston

Attaching the above change as a patch.
It replaces this particular patch in the series.

The other two patches are not strictly necessary with this change, but
don't hurt.


--
Regards,
Shyam

--0000000000007cc2a705ff16ef9a
Content-Type: application/octet-stream; 
	name="0001-cifs-remove-smb-session-from-list-rest-of-the-cleanu.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-remove-smb-session-from-list-rest-of-the-cleanu.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ljdxmdse0>
X-Attachment-Id: f_ljdxmdse0

RnJvbSBhNGM0M2JkOGU1ODZhZjZkMzNjYWJiZmU5MGZlOWE5ZDRmMzFkNDY0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBNb24sIDI2IEp1biAyMDIzIDA4OjE5OjA4ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogcmVtb3ZlIHNtYiBzZXNzaW9uIGZyb20gbGlzdCByZXN0IG9mIHRoZSBjbGVhbnVwCgpU
aGVyZSBpcyBhIHdpbmRvdyBiZXR3ZWVuIHJlZmNvdW50IHJlYWNoaW5nIDAgYW5kIGFjdHVhbGx5
CnJlbW92aW5nIHRoZSBzZXMgb2ZmIHRoZSBsaXN0IGluIGNpZnNfcHV0X3NtYl9zZXMuIER1cmlu
Zwp0aGlzIHdpbmRvdywgc29tZSBvdGhlciB1c2VycyBtYXkgYnVtcCB1cCB0aGUgcmVmY291bnQg
YW5kCnN0YXJ0IHVzaW5nIGl0LgoKVGhpcyBjaGFuZ2UgZml4ZXMgaXQgYnkgZWxpbWluYXRpbmcg
dGhlIHdpbmRvdywgYnkgcmVtb3ZpbmcKdGhlIHNlcyBvZmYgdGhlIGxpc3QgZmlyc3QsIHRoZW4g
ZHJvcHBpbmcgdGhlIGxvY2suCgpTdWdnZXN0ZWQtYnk6IFdpbnN0b24gV2VuIDx3ZW50YW9AdW5p
b250ZWNoLmNvbT4KU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9z
b2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2Nvbm5lY3QuYyB8IDYgKystLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Zz
L3NtYi9jbGllbnQvY29ubmVjdC5jIGIvZnMvc21iL2NsaWVudC9jb25uZWN0LmMKaW5kZXggOWQx
NjYyNmU3YTY2Li43ODg3NGViMjUzN2QgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY29ubmVj
dC5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jCkBAIC0xOTYzLDEwICsxOTYzLDExIEBA
IHZvaWQgX19jaWZzX3B1dF9zbWJfc2VzKHN0cnVjdCBjaWZzX3NlcyAqc2VzKQogCQlzcGluX3Vu
bG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCQlyZXR1cm47CiAJfQotCXNwaW5fdW5sb2NrKCZj
aWZzX3RjcF9zZXNfbG9jayk7CiAKIAkvKiBzZXNfY291bnQgY2FuIG5ldmVyIGdvIG5lZ2F0aXZl
ICovCiAJV0FSTl9PTihzZXMtPnNlc19jb3VudCA8IDApOworCWxpc3RfZGVsX2luaXQoJnNlcy0+
c21iX3Nlc19saXN0KTsKKwlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCiAJc3Bp
bl9sb2NrKCZzZXMtPnNlc19sb2NrKTsKIAlpZiAoc2VzLT5zZXNfc3RhdHVzID09IFNFU19HT09E
KQpAQCAtMTk4Niw5ICsxOTg3LDYgQEAgdm9pZCBfX2NpZnNfcHV0X3NtYl9zZXMoc3RydWN0IGNp
ZnNfc2VzICpzZXMpCiAJCWNpZnNfZnJlZV9pcGMoc2VzKTsKIAl9CiAKLQlzcGluX2xvY2soJmNp
ZnNfdGNwX3Nlc19sb2NrKTsKLQlsaXN0X2RlbF9pbml0KCZzZXMtPnNtYl9zZXNfbGlzdCk7Ci0J
c3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKIAogCWNoYW5fY291bnQgPSBzZXMtPmNo
YW5fY291bnQ7CiAKLS0gCjIuMzQuMQoK
--0000000000007cc2a705ff16ef9a--
