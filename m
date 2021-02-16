Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94FCC433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 22:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E68464E68
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 22:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhBPWbr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Feb 2021 17:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhBPWbq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Feb 2021 17:31:46 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E22C06174A
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 14:31:05 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id z11so18420611lfb.9
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 14:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d8XvAYkUi7mAxZxiPmY7Ipu2heFpJuSq5x39bDpTack=;
        b=OJlqjmB1NgvSHEf4CJ57LF1tP8oDx1oq/6xyZZbE+mTrJoO3Xc58n5avWhm3BGPkq1
         kfripTWZcgF5W/AADM6AzWuuh1LtKSS9EhjQea8PwaGXBcbq7BZaDGTbi5Llr1/qbwNP
         BbsjTTdQYNp9HBb4Gsj+tXCr7WWcsxmWnDvJeoeWLDg21ekqZL/0Tjli2nzuMhvm+NiD
         7WKYLeXWiecaxVTtUMLzkNHeSoyFwvqOSAn+wjwbbXFw/oXY455tU1PQmjtB1vqoKd+n
         c8pGApQPXQ0GWHZO98wLwebeArOvEuQYpfG6xVEjNcm+kDcs5rFwio3LEPWQDZEiaTJI
         lpkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d8XvAYkUi7mAxZxiPmY7Ipu2heFpJuSq5x39bDpTack=;
        b=p46Q+naWZtwi7ihmgZF/gV50sRk/Qehkcw0A2RDAuqBPX8/uuSDbmRVb3YOj0fARNp
         OAVfsND4q9tcN6XlAABoC2jJN+t/P7G4G2mnefbMT/G6DfnqfnbMdQLduUkRgRGwSNhP
         TVKcUK0Q0ieAa0RnqDeaQizT6MDxc69ujbVDCyOJGFFrK6WtVF5R4BAr1UAb3r142y0M
         dd/BiXr0jiTgoyLjEK99Mq/4CFQoq1posI740LbJf2f4bsasyZD5Q8COCUzkyDIZtngD
         3YzVUKtIteK7PgJTgkeGjMxpNky8ANg5zpdoAD2vGzxW04x6bfadL7pb+k77BuQqaP+g
         xsxQ==
X-Gm-Message-State: AOAM533JoCKyCsINdqbwH7+t6bzx6UT9gWJEDVzrdIYFqJAlOU3YDFhB
        cAdDpLXN1ALffN0kemgPSBo3EN/k0wtoz78Q1yd+3Ne7U5W83Q==
X-Google-Smtp-Source: ABdhPJxHd9nd0Zrtrq+/3QTYzFYgMsjf18u0HtXxgsAUFj2hSPeLcg1YVqa9lGmkBHomkqIlDkP+Wp6wWOTwwcFV0b8=
X-Received: by 2002:a19:910e:: with SMTP id t14mr13520047lfd.282.1613514663962;
 Tue, 16 Feb 2021 14:31:03 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com> <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com> <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
 <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
 <87lfbyn647.fsf@suse.com> <CANT5p=qJjeVk1HDhvaiAQSYH3mj-rNBNA-j2TAUnoqQVTOQ_Ww@mail.gmail.com>
 <875z2yn0lx.fsf@suse.com> <CAKywueRoFL17DiMzmorZcd=OJvDY_8+P8WxGqKDx-tdnJrr_HQ@mail.gmail.com>
 <6aad7fc3-3c3f-848c-4d65-e5c7f1dd8107@talpey.com> <CANT5p=o4=uy8HV4L_nXfPUJ=bUO5Oyf8p6=Y7dY5PxsabHxJYQ@mail.gmail.com>
In-Reply-To: <CANT5p=o4=uy8HV4L_nXfPUJ=bUO5Oyf8p6=Y7dY5PxsabHxJYQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Feb 2021 16:30:52 -0600
Message-ID: <CAH2r5mu-n=9zZaAj5iA3zonq9enU+eYS5mZw8NHCXdnVjVZMeQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by conn_id.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000062c3b005bb7ba877"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000062c3b005bb7ba877
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I updated the patch (converting a few places that should be calling
seq_puts instead of seq_printf - see attached) but will also send a
followon to the list to see if we clean the /proc/fs/cifs/DebugData a
little more.

On Tue, Feb 16, 2021 at 6:29 AM Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
>
> Hi Pavel,
>
> Thanks for the review.
> As Tom pointed out, the server name is currently a field in
> TCP_Session_Info struct.
> We do store the struct sockaddr_storage, which I'm guessing holds the
> IP address in binary format, and we could use that. And may need to
> consider IPv4 vs IPv6 when we do it.
> I'll submit that as a new patch later on.
>
> Hi Tom,
>
> > Including the transport type (TCP, RDMA...) and multichannel attributes
> > (link speed, RSS count, ...) would be useful too.
> Can you please clarify this for me?
> From what I can see from the code, RDMA connection DebugData is a
> superset of TCP connection. The RDMA specific details get printed only
> when server->rdma is set.
>
> Regards,
> Shyam
>
> On Thu, Feb 11, 2021 at 11:41 AM Tom Talpey <tom@talpey.com> wrote:
> >
> > On 2/11/2021 12:12 PM, Pavel Shilovsky wrote:
> > > Hi Shyam,
> > >
> > > The output looks very informative! I have one comment:
> > >
> > > Servers:
> > > 1) ConnectionId: 0x1
> > > Number of credits: 326 Dialect 0x311
> > > TCP status: 1 Instance: 1
> > > Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
> > > In Send: 0 In MaxReq Wait: 0
> > >
> > > Sessions:
> > > 1) Name: 10.229.158.38 Uses: 1 Capability: 0x300077 Session Status: 1
> > >                       ^^^^
> > > Isn't this name (or hostname) a property of the connection? I would
> > > expect an IP or a hostname to be printed in the connection settings
> > > above.
> >
> > The servername is a property of the session, in this case since the
> > mount specified a dotted quad, it would correctly appear as the
> > servername at this level.
> >
> > However, I definitely agree that an IP address is important in the
> > per-connection (channel) stanzas. Multichannel, multihoming, witness
> > redirects, and any number of things can vary among them. It would
> > be useful indeed to display them.
> >
> > Including the transport type (TCP, RDMA...) and multichannel attributes
> > (link speed, RSS count, ...) would be useful too.
> >
> > Tom.
> >
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D1=87=D1=82, 11 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 06:24,=
 Aur=C3=A9lien Aptel <aaptel@suse.com>:
> > >>
> > >> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > >>> I noticed that the output looks rather odd when used with multichan=
nel.
> > >>> Attaching a revised patch with the changes.
> > >>>
> > >>> Also attached a sample of new output.
> > >>
> > >> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > >>
> > >> --
> > >> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > >> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > >> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrn=
berg, DE
> > >> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG =
M=C3=BCnchen)
> > >>
> > >
>
>
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve

--00000000000062c3b005bb7ba877
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Reformat-DebugData-and-index-connections-by-con.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Reformat-DebugData-and-index-connections-by-con.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kl8kyllu0>
X-Attachment-Id: f_kl8kyllu0

RnJvbSAwM2U5YmIxYTBiNDAzYzI5ZDVlODY3OWJlNjhhZGRjMjMwNDcyMzkwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDMgRmViIDIwMjEgMjM6Mjc6NTIgLTA4MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBSZWZvcm1hdCBEZWJ1Z0RhdGEgYW5kIGluZGV4IGNvbm5lY3Rpb25zIGJ5IGNvbm5faWQu
CgpSZWZvcm1hdCB0aGUgb3V0cHV0IG9mIC9wcm9jL2ZzL2NpZnMvRGVidWdEYXRhIHRvIHByaW50
IHRoZQpjb25uX2lkIGZvciBlYWNoIGNvbm5lY3Rpb24uIEFsc28gcmVvcmRlcmVkIGFuZCBudW1i
ZXJlZCB0aGUgZGF0YQppbnRvIGEgbW9yZSByZWFkZXItZnJpZW5kbHkgZm9ybWF0LgoKVGhpcyBp
cyB3aGF0IHRoZSBuZXcgZm9ybWF0IGxvb2tzIGxpa2U6CiQgY2F0IC9wcm9jL2ZzL2NpZnMvRGVi
dWdEYXRhCkRpc3BsYXkgSW50ZXJuYWwgQ0lGUyBEYXRhIFN0cnVjdHVyZXMgZm9yIERlYnVnZ2lu
ZwotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KQ0lG
UyBWZXJzaW9uIDIuMzAKRmVhdHVyZXM6IERGUyxGU0NBQ0hFLFNUQVRTLERFQlVHLEFMTE9XX0lO
U0VDVVJFX0xFR0FDWSxXRUFLX1BXX0hBU0gsQ0lGU19QT1NJWCxVUENBTEwoU1BORUdPKSxYQVRU
UixBQ0wKQ0lGU01heEJ1ZlNpemU6IDE2Mzg0CkFjdGl2ZSBWRlMgUmVxdWVzdHM6IDAKClNlcnZl
cnM6CjEpIENvbm5lY3Rpb25JZDogMHgxCk51bWJlciBvZiBjcmVkaXRzOiAzNzEgRGlhbGVjdCAw
eDMwMApUQ1Agc3RhdHVzOiAxIEluc3RhbmNlOiAxCkxvY2FsIFVzZXJzIFRvIFNlcnZlcjogMSBT
ZWNNb2RlOiAweDEgUmVxIE9uIFdpcmU6IDAgSW4gU2VuZDogMCBJbiBNYXhSZXEgV2FpdDogMAoK
ICAgICAgICBTZXNzaW9uczoKICAgICAgICAxKSBOYW1lOiAxMC4xMC4xMC4xMCBVc2VzOiAxIENh
cGFiaWxpdHk6IDB4MzAwMDc3ICAgICBTZXNzaW9uIFN0YXR1czogMQogICAgICAgIFNlY3VyaXR5
IHR5cGU6IFJhd05UTE1TU1AgIFNlc3Npb25JZDogMHg3ODU1NjAwMDAwMTkKICAgICAgICBVc2Vy
OiAxMDAwIENyZWQgVXNlcjogMAoKICAgICAgICBTaGFyZXM6CiAgICAgICAgMCkgSVBDOiBcXDEw
LjEwLjEwLjEwXElQQyQgTW91bnRzOiAxIERldkluZm86IDB4MCBBdHRyaWJ1dGVzOiAweDAKICAg
ICAgICBQYXRoQ29tcG9uZW50TWF4OiAwIFN0YXR1czogMSB0eXBlOiAwIFNlcmlhbCBOdW1iZXI6
IDB4MAogICAgICAgIFNoYXJlIENhcGFiaWxpdGllczogTm9uZSAgICAgICAgU2hhcmUgRmxhZ3M6
IDB4MzAKICAgICAgICB0aWQ6IDB4MSAgICAgICAgTWF4aW1hbCBBY2Nlc3M6IDB4MTFmMDFmZgoK
ICAgICAgICAxKSBcXDEwLjEwLjEwLjEwXHNoeWFtX3Rlc3QyIE1vdW50czogMSBEZXZJbmZvOiAw
eDIwMDIwIEF0dHJpYnV0ZXM6IDB4YzcwNmZmCiAgICAgICAgUGF0aENvbXBvbmVudE1heDogMjU1
IFN0YXR1czogMSB0eXBlOiBESVNLIFNlcmlhbCBOdW1iZXI6IDB4ZDQ3MjM5NzUKICAgICAgICBT
aGFyZSBDYXBhYmlsaXRpZXM6IE5vbmUgQWxpZ25lZCwgUGFydGl0aW9uIEFsaWduZWQsICAgIFNo
YXJlIEZsYWdzOiAweDAKICAgICAgICB0aWQ6IDB4NSAgICAgICAgT3B0aW1hbCBzZWN0b3Igc2l6
ZTogMHgxMDAwICAgICBNYXhpbWFsIEFjY2VzczogMHgxZjAxZmYKCiAgICAgICAgTUlEczoKCiAg
ICAgICAgU2VydmVyIGludGVyZmFjZXM6IDMKICAgICAgICAxKSAgICAgIFNwZWVkOiAxMDAwMDAw
MDAwMCBicHMKICAgICAgICAgICAgICAgIENhcGFiaWxpdGllczogcnNzCiAgICAgICAgICAgICAg
ICBJUHY0OiAxMC4xMC4xMC4xCgogICAgICAgIDIpICAgICAgU3BlZWQ6IDEwMDAwMDAwMDAwIGJw
cwogICAgICAgICAgICAgICAgQ2FwYWJpbGl0aWVzOiByc3MKICAgICAgICAgICAgICAgIElQdjY6
IGZlODA6MDAwMDowMDAwOjAwMDA6MThiNDowMDAwOjAwMDA6MDAwMAoKICAgICAgICAzKSAgICAg
IFNwZWVkOiAxMDAwMDAwMDAwIGJwcwogICAgICAgICAgICAgICAgQ2FwYWJpbGl0aWVzOiByc3MK
ICAgICAgICAgICAgICAgIElQdjQ6IDEwLjEwLjEwLjEwCiAgICAgICAgICAgICAgICBbQ09OTkVD
VEVEXQoKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNv
bT4KUmV2aWV3ZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxvdkBtaWNyb3NvZnQuY29tPgpS
ZXZpZXdlZC1ieTogQXVyZWxpZW4gQXB0ZWwgPGFhcHRlbEBzdXNlLmNvbT4KU2lnbmVkLW9mZi1i
eTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lm
c19kZWJ1Zy5jIHwgMTE3ICsrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0t
LS0KIDEgZmlsZSBjaGFuZ2VkLCA2OCBpbnNlcnRpb25zKCspLCA0OSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNfZGVidWcuYyBiL2ZzL2NpZnMvY2lmc19kZWJ1Zy5jCmlu
ZGV4IGIyMzFkY2YxZDFmOS4uMzcwY2M4OGEzZDAyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNf
ZGVidWcuYworKysgYi9mcy9jaWZzL2NpZnNfZGVidWcuYwpAQCAtMTMzLDExICsxMzMsMTIgQEAg
Y2lmc19kdW1wX2NoYW5uZWwoc3RydWN0IHNlcV9maWxlICptLCBpbnQgaSwgc3RydWN0IGNpZnNf
Y2hhbiAqY2hhbikKIHsKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIgPSBjaGFuLT5z
ZXJ2ZXI7CiAKLQlzZXFfcHJpbnRmKG0sICJcdFx0Q2hhbm5lbCAlZCBOdW1iZXIgb2YgY3JlZGl0
czogJWQgRGlhbGVjdCAweCV4ICIKLQkJICAgIlRDUCBzdGF0dXM6ICVkIEluc3RhbmNlOiAlZCBM
b2NhbCBVc2VycyBUbyBTZXJ2ZXI6ICVkICIKLQkJICAgIlNlY01vZGU6IDB4JXggUmVxIE9uIFdp
cmU6ICVkIEluIFNlbmQ6ICVkICIKLQkJICAgIkluIE1heFJlcSBXYWl0OiAlZFxuIiwKLQkJICAg
aSsxLAorCXNlcV9wcmludGYobSwgIlxuXG5cdFx0Q2hhbm5lbDogJWQgQ29ubmVjdGlvbklkOiAw
eCVsbHgiCisJCSAgICJcblx0XHROdW1iZXIgb2YgY3JlZGl0czogJWQgRGlhbGVjdCAweCV4Igor
CQkgICAiXG5cdFx0VENQIHN0YXR1czogJWQgSW5zdGFuY2U6ICVkIgorCQkgICAiXG5cdFx0TG9j
YWwgVXNlcnMgVG8gU2VydmVyOiAlZCBTZWNNb2RlOiAweCV4IFJlcSBPbiBXaXJlOiAlZCIKKwkJ
ICAgIlxuXHRcdEluIFNlbmQ6ICVkIEluIE1heFJlcSBXYWl0OiAlZCIsCisJCSAgIGkrMSwgc2Vy
dmVyLT5jb25uX2lkLAogCQkgICBzZXJ2ZXItPmNyZWRpdHMsCiAJCSAgIHNlcnZlci0+ZGlhbGVj
dCwKIAkJICAgc2VydmVyLT50Y3BTdGF0dXMsCkBAIC0yMjcsNyArMjI4LDcgQEAgc3RhdGljIGlu
dCBjaWZzX2RlYnVnX2RhdGFfcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9pZCAqdikK
IAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXI7CiAJc3RydWN0IGNpZnNfc2VzICpzZXM7
CiAJc3RydWN0IGNpZnNfdGNvbiAqdGNvbjsKLQlpbnQgaSwgajsKKwlpbnQgYywgaSwgajsKIAog
CXNlcV9wdXRzKG0sCiAJCSAgICAiRGlzcGxheSBJbnRlcm5hbCBDSUZTIERhdGEgU3RydWN0dXJl
cyBmb3IgRGVidWdnaW5nXG4iCkBAIC0yNzUsMTQgKzI3NiwyMyBAQCBzdGF0aWMgaW50IGNpZnNf
ZGVidWdfZGF0YV9wcm9jX3Nob3coc3RydWN0IHNlcV9maWxlICptLCB2b2lkICp2KQogCXNlcV9w
dXRjKG0sICdcbicpOwogCXNlcV9wcmludGYobSwgIkNJRlNNYXhCdWZTaXplOiAlZFxuIiwgQ0lG
U01heEJ1ZlNpemUpOwogCXNlcV9wcmludGYobSwgIkFjdGl2ZSBWRlMgUmVxdWVzdHM6ICVkXG4i
LCBHbG9iYWxUb3RhbEFjdGl2ZVhpZCk7Ci0Jc2VxX3ByaW50ZihtLCAiU2VydmVyczoiKTsKIAot
CWkgPSAwOworCXNlcV9wcmludGYobSwgIlxuU2VydmVyczogIik7CisKKwljID0gMDsKIAlzcGlu
X2xvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKIAlsaXN0X2Zvcl9lYWNoKHRtcDEsICZjaWZzX3Rj
cF9zZXNfbGlzdCkgewogCQlzZXJ2ZXIgPSBsaXN0X2VudHJ5KHRtcDEsIHN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8sCiAJCQkJICAgIHRjcF9zZXNfbGlzdCk7CiAKKwkJLyogY2hhbm5lbCBpbmZvIHdp
bGwgYmUgcHJpbnRlZCBhcyBhIHBhcnQgb2Ygc2Vzc2lvbnMgYmVsb3cgKi8KKwkJaWYgKHNlcnZl
ci0+aXNfY2hhbm5lbCkKKwkJCWNvbnRpbnVlOworCisJCWMrKzsKKwkJc2VxX3ByaW50ZihtLCAi
XG4lZCkgQ29ubmVjdGlvbklkOiAweCVsbHggIiwKKwkJCWMsIHNlcnZlci0+Y29ubl9pZCk7CisK
ICNpZmRlZiBDT05GSUdfQ0lGU19TTUJfRElSRUNUCiAJCWlmICghc2VydmVyLT5yZG1hKQogCQkJ
Z290byBza2lwX3JkbWE7CkBAIC0zNjIsNDYgKzM3Miw0OCBAQCBzdGF0aWMgaW50IGNpZnNfZGVi
dWdfZGF0YV9wcm9jX3Nob3coc3RydWN0IHNlcV9maWxlICptLCB2b2lkICp2KQogCQlpZiAoc2Vy
dmVyLT5wb3NpeF9leHRfc3VwcG9ydGVkKQogCQkJc2VxX3ByaW50ZihtLCAiIHBvc2l4Iik7CiAK
LQkJaSsrOworCQlpZiAoc2VydmVyLT5yZG1hKQorCQkJc2VxX3ByaW50ZihtLCAiXG5SRE1BICIp
OworCQlzZXFfcHJpbnRmKG0sICJcblRDUCBzdGF0dXM6ICVkIEluc3RhbmNlOiAlZCIKKwkJCQki
XG5Mb2NhbCBVc2VycyBUbyBTZXJ2ZXI6ICVkIFNlY01vZGU6IDB4JXggUmVxIE9uIFdpcmU6ICVk
IiwKKwkJCQlzZXJ2ZXItPnRjcFN0YXR1cywKKwkJCQlzZXJ2ZXItPnJlY29ubmVjdF9pbnN0YW5j
ZSwKKwkJCQlzZXJ2ZXItPnNydl9jb3VudCwKKwkJCQlzZXJ2ZXItPnNlY19tb2RlLCBpbl9mbGln
aHQoc2VydmVyKSk7CisKKwkJc2VxX3ByaW50ZihtLCAiXG5JbiBTZW5kOiAlZCBJbiBNYXhSZXEg
V2FpdDogJWQiLAorCQkJCWF0b21pY19yZWFkKCZzZXJ2ZXItPmluX3NlbmQpLAorCQkJCWF0b21p
Y19yZWFkKCZzZXJ2ZXItPm51bV93YWl0ZXJzKSk7CisKKwkJc2VxX3ByaW50ZihtLCAiXG5cblx0
U2Vzc2lvbnM6ICIpOworCQlpID0gMDsKIAkJbGlzdF9mb3JfZWFjaCh0bXAyLCAmc2VydmVyLT5z
bWJfc2VzX2xpc3QpIHsKIAkJCXNlcyA9IGxpc3RfZW50cnkodG1wMiwgc3RydWN0IGNpZnNfc2Vz
LAogCQkJCQkgc21iX3Nlc19saXN0KTsKKwkJCWkrKzsKIAkJCWlmICgoc2VzLT5zZXJ2ZXJEb21h
aW4gPT0gTlVMTCkgfHwKIAkJCQkoc2VzLT5zZXJ2ZXJPUyA9PSBOVUxMKSB8fAogCQkJCShzZXMt
PnNlcnZlck5PUyA9PSBOVUxMKSkgewotCQkJCXNlcV9wcmludGYobSwgIlxuJWQpIE5hbWU6ICVz
IFVzZXM6ICVkIENhcGFiaWxpdHk6IDB4JXhcdFNlc3Npb24gU3RhdHVzOiAlZCAiLAorCQkJCXNl
cV9wcmludGYobSwgIlxuXHQlZCkgTmFtZTogJXMgVXNlczogJWQgQ2FwYWJpbGl0eTogMHgleFx0
U2Vzc2lvbiBTdGF0dXM6ICVkICIsCiAJCQkJCWksIHNlcy0+c2VydmVyTmFtZSwgc2VzLT5zZXNf
Y291bnQsCiAJCQkJCXNlcy0+Y2FwYWJpbGl0aWVzLCBzZXMtPnN0YXR1cyk7CiAJCQkJaWYgKHNl
cy0+c2Vzc2lvbl9mbGFncyAmIFNNQjJfU0VTU0lPTl9GTEFHX0lTX0dVRVNUKQotCQkJCQlzZXFf
cHJpbnRmKG0sICJHdWVzdFx0Iik7CisJCQkJCXNlcV9wcmludGYobSwgIkd1ZXN0ICIpOwogCQkJ
CWVsc2UgaWYgKHNlcy0+c2Vzc2lvbl9mbGFncyAmIFNNQjJfU0VTU0lPTl9GTEFHX0lTX05VTEwp
Ci0JCQkJCXNlcV9wcmludGYobSwgIkFub255bW91c1x0Iik7CisJCQkJCXNlcV9wcmludGYobSwg
IkFub255bW91cyAiKTsKIAkJCX0gZWxzZSB7CiAJCQkJc2VxX3ByaW50ZihtLAotCQkJCSAgICAi
XG4lZCkgTmFtZTogJXMgIERvbWFpbjogJXMgVXNlczogJWQgT1M6IgotCQkJCSAgICAiICVzXG5c
dE5PUzogJXNcdENhcGFiaWxpdHk6IDB4JXhcblx0U01CIgotCQkJCSAgICAiIHNlc3Npb24gc3Rh
dHVzOiAlZCAiLAorCQkJCSAgICAiXG5cdCVkKSBOYW1lOiAlcyAgRG9tYWluOiAlcyBVc2VzOiAl
ZCBPUzogJXMgIgorCQkJCSAgICAiXG5cdE5PUzogJXNcdENhcGFiaWxpdHk6IDB4JXgiCisJCQkJ
CSJcblx0U01CIHNlc3Npb24gc3RhdHVzOiAlZCAiLAogCQkJCWksIHNlcy0+c2VydmVyTmFtZSwg
c2VzLT5zZXJ2ZXJEb21haW4sCiAJCQkJc2VzLT5zZXNfY291bnQsIHNlcy0+c2VydmVyT1MsIHNl
cy0+c2VydmVyTk9TLAogCQkJCXNlcy0+Y2FwYWJpbGl0aWVzLCBzZXMtPnN0YXR1cyk7CiAJCQl9
CiAKLQkJCXNlcV9wcmludGYobSwiU2VjdXJpdHkgdHlwZTogJXNcbiIsCisJCQlzZXFfcHJpbnRm
KG0sICJcblx0U2VjdXJpdHkgdHlwZTogJXMgIiwKIAkJCQlnZXRfc2VjdXJpdHlfdHlwZV9zdHIo
c2VydmVyLT5vcHMtPnNlbGVjdF9zZWN0eXBlKHNlcnZlciwgc2VzLT5zZWN0eXBlKSkpOwogCi0J
CQlpZiAoc2VydmVyLT5yZG1hKQotCQkJCXNlcV9wcmludGYobSwgIlJETUFcblx0Iik7Ci0JCQlz
ZXFfcHJpbnRmKG0sICJUQ1Agc3RhdHVzOiAlZCBJbnN0YW5jZTogJWRcblx0TG9jYWwgVXNlcnMg
VG8gIgotCQkJCSAgICJTZXJ2ZXI6ICVkIFNlY01vZGU6IDB4JXggUmVxIE9uIFdpcmU6ICVkIiwK
LQkJCQkgICBzZXJ2ZXItPnRjcFN0YXR1cywKLQkJCQkgICBzZXJ2ZXItPnJlY29ubmVjdF9pbnN0
YW5jZSwKLQkJCQkgICBzZXJ2ZXItPnNydl9jb3VudCwKLQkJCQkgICBzZXJ2ZXItPnNlY19tb2Rl
LCBpbl9mbGlnaHQoc2VydmVyKSk7Ci0KLQkJCXNlcV9wcmludGYobSwgIiBJbiBTZW5kOiAlZCBJ
biBNYXhSZXEgV2FpdDogJWQiLAotCQkJCWF0b21pY19yZWFkKCZzZXJ2ZXItPmluX3NlbmQpLAot
CQkJCWF0b21pY19yZWFkKCZzZXJ2ZXItPm51bV93YWl0ZXJzKSk7Ci0KIAkJCS8qIGR1bXAgc2Vz
c2lvbiBpZCBoZWxwZnVsIGZvciB1c2Ugd2l0aCBuZXR3b3JrIHRyYWNlICovCiAJCQlzZXFfcHJp
bnRmKG0sICIgU2Vzc2lvbklkOiAweCVsbHgiLCBzZXMtPlN1aWQpOwogCQkJaWYgKHNlcy0+c2Vz
c2lvbl9mbGFncyAmIFNNQjJfU0VTU0lPTl9GTEFHX0VOQ1JZUFRfREFUQSkKQEAgLTQxNCwxMyAr
NDI2LDEzIEBAIHN0YXRpYyBpbnQgY2lmc19kZWJ1Z19kYXRhX3Byb2Nfc2hvdyhzdHJ1Y3Qgc2Vx
X2ZpbGUgKm0sIHZvaWQgKnYpCiAJCQkJICAgZnJvbV9rdWlkKCZpbml0X3VzZXJfbnMsIHNlcy0+
Y3JlZF91aWQpKTsKIAogCQkJaWYgKHNlcy0+Y2hhbl9jb3VudCA+IDEpIHsKLQkJCQlzZXFfcHJp
bnRmKG0sICJcblxuXHRFeHRyYSBDaGFubmVsczogJXp1XG4iLAorCQkJCXNlcV9wcmludGYobSwg
IlxuXG5cdEV4dHJhIENoYW5uZWxzOiAlenUgIiwKIAkJCQkJICAgc2VzLT5jaGFuX2NvdW50LTEp
OwogCQkJCWZvciAoaiA9IDE7IGogPCBzZXMtPmNoYW5fY291bnQ7IGorKykKIAkJCQkJY2lmc19k
dW1wX2NoYW5uZWwobSwgaiwgJnNlcy0+Y2hhbnNbal0pOwogCQkJfQogCi0JCQlzZXFfcHV0cyht
LCAiXG5cblx0U2hhcmVzOiIpOworCQkJc2VxX3B1dHMobSwgIlxuXG5cdFNoYXJlczogIik7CiAJ
CQlqID0gMDsKIAogCQkJc2VxX3ByaW50ZihtLCAiXG5cdCVkKSBJUEM6ICIsIGopOwpAQCAtNDM3
LDM4ICs0NDksNDUgQEAgc3RhdGljIGludCBjaWZzX2RlYnVnX2RhdGFfcHJvY19zaG93KHN0cnVj
dCBzZXFfZmlsZSAqbSwgdm9pZCAqdikKIAkJCQljaWZzX2RlYnVnX3Rjb24obSwgdGNvbik7CiAJ
CQl9CiAKLQkJCXNlcV9wdXRzKG0sICJcblx0TUlEczpcbiIpOwotCi0JCQlzcGluX2xvY2soJkds
b2JhbE1pZF9Mb2NrKTsKLQkJCWxpc3RfZm9yX2VhY2godG1wMywgJnNlcnZlci0+cGVuZGluZ19t
aWRfcSkgewotCQkJCW1pZF9lbnRyeSA9IGxpc3RfZW50cnkodG1wMywgc3RydWN0IG1pZF9xX2Vu
dHJ5LAotCQkJCQlxaGVhZCk7Ci0JCQkJc2VxX3ByaW50ZihtLCAiXHRTdGF0ZTogJWQgY29tOiAl
ZCBwaWQ6IgotCQkJCQkgICAgICAiICVkIGNiZGF0YTogJXAgbWlkICVsbHVcbiIsCi0JCQkJCSAg
ICAgIG1pZF9lbnRyeS0+bWlkX3N0YXRlLAotCQkJCQkgICAgICBsZTE2X3RvX2NwdShtaWRfZW50
cnktPmNvbW1hbmQpLAotCQkJCQkgICAgICBtaWRfZW50cnktPnBpZCwKLQkJCQkJICAgICAgbWlk
X2VudHJ5LT5jYWxsYmFja19kYXRhLAotCQkJCQkgICAgICBtaWRfZW50cnktPm1pZCk7Ci0JCQl9
Ci0JCQlzcGluX3VubG9jaygmR2xvYmFsTWlkX0xvY2spOwotCiAJCQlzcGluX2xvY2soJnNlcy0+
aWZhY2VfbG9jayk7CiAJCQlpZiAoc2VzLT5pZmFjZV9jb3VudCkKLQkJCQlzZXFfcHJpbnRmKG0s
ICJcblx0U2VydmVyIGludGVyZmFjZXM6ICV6dVxuIiwKKwkJCQlzZXFfcHJpbnRmKG0sICJcblxu
XHRTZXJ2ZXIgaW50ZXJmYWNlczogJXp1IiwKIAkJCQkJICAgc2VzLT5pZmFjZV9jb3VudCk7CiAJ
CQlmb3IgKGogPSAwOyBqIDwgc2VzLT5pZmFjZV9jb3VudDsgaisrKSB7CiAJCQkJc3RydWN0IGNp
ZnNfc2VydmVyX2lmYWNlICppZmFjZTsKIAogCQkJCWlmYWNlID0gJnNlcy0+aWZhY2VfbGlzdFtq
XTsKLQkJCQlzZXFfcHJpbnRmKG0sICJcdCVkKSIsIGopOworCQkJCXNlcV9wcmludGYobSwgIlxu
XHQlZCkiLCBqKzEpOwogCQkJCWNpZnNfZHVtcF9pZmFjZShtLCBpZmFjZSk7CiAJCQkJaWYgKGlz
X3Nlc191c2luZ19pZmFjZShzZXMsIGlmYWNlKSkKIAkJCQkJc2VxX3B1dHMobSwgIlx0XHRbQ09O
TkVDVEVEXVxuIik7CiAJCQl9CisJCQlpZiAoaiA9PSAwKQorCQkJCXNlcV9wcmludGYobSwgIlxu
XHRbTk9ORV0iKTsKIAkJCXNwaW5fdW5sb2NrKCZzZXMtPmlmYWNlX2xvY2spOwogCQl9CisJCWlm
IChpID09IDApCisJCQlzZXFfcHJpbnRmKG0sICJcblx0XHRbTk9ORV0iKTsKKworCQlzZXFfcHV0
cyhtLCAiXG5cblx0TUlEczogIik7CisJCXNwaW5fbG9jaygmR2xvYmFsTWlkX0xvY2spOworCQls
aXN0X2Zvcl9lYWNoKHRtcDMsICZzZXJ2ZXItPnBlbmRpbmdfbWlkX3EpIHsKKwkJCW1pZF9lbnRy
eSA9IGxpc3RfZW50cnkodG1wMywgc3RydWN0IG1pZF9xX2VudHJ5LAorCQkJCQlxaGVhZCk7CisJ
CQlzZXFfcHJpbnRmKG0sICJcblx0U3RhdGU6ICVkIGNvbTogJWQgcGlkOiIKKwkJCQkJIiAlZCBj
YmRhdGE6ICVwIG1pZCAlbGx1XG4iLAorCQkJCQltaWRfZW50cnktPm1pZF9zdGF0ZSwKKwkJCQkJ
bGUxNl90b19jcHUobWlkX2VudHJ5LT5jb21tYW5kKSwKKwkJCQkJbWlkX2VudHJ5LT5waWQsCisJ
CQkJCW1pZF9lbnRyeS0+Y2FsbGJhY2tfZGF0YSwKKwkJCQkJbWlkX2VudHJ5LT5taWQpOworCQl9
CisJCXNwaW5fdW5sb2NrKCZHbG9iYWxNaWRfTG9jayk7CisJCXNlcV9wcmludGYobSwgIlxuLS1c
biIpOwogCX0KKwlpZiAoYyA9PSAwKQorCQlzZXFfcHJpbnRmKG0sICJcblx0W05PTkVdIik7CisK
IAlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCXNlcV9wdXRjKG0sICdcbicpOwog
Ci0tIAoyLjI3LjAKCg==
--00000000000062c3b005bb7ba877--
