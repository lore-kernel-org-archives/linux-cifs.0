Return-Path: <SRS0=IAhR=2D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C1CC43603
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3982020663
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="speelhg4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfLMAej (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Dec 2019 19:34:39 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42560 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731519AbfLMAej (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Dec 2019 19:34:39 -0500
Received: by mail-io1-f68.google.com with SMTP id f82so595708ioa.9
        for <linux-cifs@vger.kernel.org>; Thu, 12 Dec 2019 16:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MXVfdR+rS8uQn8n3uA/5oyF09QdRHUCtBsy4RzTS+Hw=;
        b=speelhg49VpoOYqQzYWecHGfoq38rC17VpZqy8gQ+8pOoOp+SMvE/ymt5KH7leYdwO
         8g6754ugrxrtRy5nEVRslB9cPebRf80yWq1d1ngytF2NC8ByHPCD6zSUm4LQW+c0rENU
         t0O7/Am3cpe5bFUEfR6Oj79KzZ1T7nEEXqaicaSbUU9fes7mmvv1vAfHKdV/3rHX9SkI
         aPdXGvAJvbJOkRF6MXsjBTMftd1n0MX2NUC/thJH6ViCd1TdBJeDbLQ0rBEYqWOJ/1p+
         QPEZhxLKQG0ii8+NK29Xz8FethdEZh2rplolsbGYkV70/GELnZx7TvezQawDYR9qL7Y6
         RJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MXVfdR+rS8uQn8n3uA/5oyF09QdRHUCtBsy4RzTS+Hw=;
        b=TSy5wGOSILaN4BwxChrmDin1E4se5eLcel1aorB1czJ7+NDd88XG4EmVLGfBvLbPAq
         dStC/YLrOMVFxvBVxFRHk2uKQDNhlBNxsl3PA+YCEwi6flb1f/+8jd3Lt6BN44aG/TN6
         qB5PejYX/9sFwOlZEqTquCRVPSKmFw9Ne29rEvPApPPwWt5FWYZ0P5NlbIQ5WaHbBwBc
         FLL+CsktwInHFLF5QNhrLVvYQZOTIXb1aYNYAsiWxBp3dRq40FAxPiErMOCB2wrdVCWS
         6sEsoGfrM8mbrsTl7ZOMpB8OzyYV+Ud8cVRvF+J1z8kVbILoMJLyYO4jBrEdajh1UynN
         pqtA==
X-Gm-Message-State: APjAAAXCv+8is3/nQXkVaZYPD18ts96bm7oejzAW9ksq8dOzgw02T8aM
        moJ9HX6pdRgIicuzvZhzXBhAzXSp5TfQiP8Hsyo=
X-Google-Smtp-Source: APXvYqxh8WtJMaG1bojGY+SFbHykBzw85cdYqNcfdw+Fy56aAeJtnAErG+n9wLDc+l9fXWzR1v7SxT4WCqUku7xgYr0=
X-Received: by 2002:a02:cd31:: with SMTP id h17mr10223749jaq.94.1576197278849;
 Thu, 12 Dec 2019 16:34:38 -0800 (PST)
MIME-Version: 1.0
References: <20190924045611.21689-1-kdsouza@redhat.com> <87o8yqf4f6.fsf@suse.com>
 <CAA_-hQL8MpS9YEcaQpuiQnbsuJwerutnbxWhE-Fyk1X4jpvwcw@mail.gmail.com>
 <87k19ef0si.fsf@suse.com> <CAN05THSfA9e1DP9+nM=CkgU-mKRnUeJp2p96umrOA3aBiWe9Gg@mail.gmail.com>
 <87h84hf4k6.fsf@suse.com> <CAKywueRD76842q22OpZePdhO9+febBv-CxdhZZiCjCrCjrpAGQ@mail.gmail.com>
In-Reply-To: <CAKywueRD76842q22OpZePdhO9+febBv-CxdhZZiCjCrCjrpAGQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 13 Dec 2019 10:34:27 +1000
Message-ID: <CAN05THT=mH5_iNnJ581w8V2f2+Rxr_KkYfy9gibu0-ZOsDV2RQ@mail.gmail.com>
Subject: Re: [PATCH] smb2quota.py: Userspace helper to display quota
 information for the Linux SMB client file system (CIFS)
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e7033c05998b0654"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e7033c05998b0654
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patch is pretty small.
You might need to massage it a little bit since I recall that we
renamed the smb2quota util
but that is not yet in github

On Fri, Dec 13, 2019 at 10:23 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> Hi everyone,
>
> Sorry for the delay in responses. I agree with the idea to re-write
> smbinfo in python since it gives more flexibility. And yes, we will
> need installers for python utilities in order to properly ship those.
>
> I am going to cut off the next release at the beginning of next week.
> The "next" branch is updated to have everything that I have got for
> now, except smbinfo re-write in python that I would like to postpone
> for the next release.
>
> https://github.com/piastry/cifs-utils/commits/next
>
> If any patch is missed or If someone has any WIP patches that need to
> be in the next release, please let me know.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D1=87=D1=82, 10 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 00:22, Aur=C3=A9=
lien Aptel <aaptel@suse.com>:
> >
> > "ronnie sahlberg" <ronniesahlberg@gmail.com> writes:
> > > I think it would be good to have these tools as part of the actual in=
stall.
> > > They are in python so they are imho much more useful to the target us=
ers
> > > (sysadmins) than a utility written in C.
> > > (I kind of regret that smbinfo is in C, it should have been python
> > > too:-( )
> >
> > I completely agree, we could rewrite smbinfo in python.
> >
> > > Maybe we just need to decide on a naming prefix for these utilities
> > > and then there shouldn't be
> > > a problem to add many small useful tools.
> >
> > We can also make the C code call the python script for now (or vice
> > versa, while smbinfo gets rewritten).
> >
> > > The nice thing with small python tools is that it is so easy to tweak
> > > them to specific usecases.
> >
> > +100
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)

--000000000000e7033c05998b0654
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Install-smb2quota-and-its-manpage.patch"
Content-Disposition: attachment; 
	filename="0001-Install-smb2quota-and-its-manpage.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k43f4qvu0>
X-Attachment-Id: f_k43f4qvu0

RnJvbSBjYjE5MmIzMTU5ZjQwNGI2YTU3MGQ4NTZiNDQwYWE0NDgzMmRlZGExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IEZyaSwgMTMgRGVjIDIwMTkgMTA6MzA6MDAgKzEwMDAKU3ViamVjdDogW1BBVENIXSBJ
bnN0YWxsIHNtYjJxdW90YSBhbmQgaXRzIG1hbnBhZ2UKClNpZ25lZC1vZmYtYnk6IFJvbm5pZSBT
YWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KLS0tCiBNYWtlZmlsZS5hbSAgICAgICAgICAg
ICAgIHwgNiArKysrKysKIGNvbmZpZ3VyZS5hYyAgICAgICAgICAgICAgfCA2ICsrKysrKwogc21i
MnF1b3RhLnB5ID0+IHNtYjJxdW90YSB8IDAKIDMgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9u
cygrKQogcmVuYW1lIHNtYjJxdW90YS5weSA9PiBzbWIycXVvdGEgKDEwMCUpCgpkaWZmIC0tZ2l0
IGEvTWFrZWZpbGUuYW0gYi9NYWtlZmlsZS5hbQppbmRleCA4MjkxYjk5Li4yYWRjODAwIDEwMDY0
NAotLS0gYS9NYWtlZmlsZS5hbQorKysgYi9NYWtlZmlsZS5hbQpAQCAtMjUsNiArMjUsNyBAQCBS
U1QyTUFOID0gJChoYXZlX3JzdDJtYW4pIC0tc3ludGF4LWhpZ2hsaWdodD1ub25lICQ8ICRACiAK
IENMRUFORklMRVMgPQogYmluX1BST0dSQU1TID0KK2Jpbl9TQ1JJUFRTID0KIHNiaW5fUFJPR1JB
TVMgPQogCiBpZiBDT05GSUdfQ0lGU1VQQ0FMTApAQCAtODUsNiArODYsMTEgQEAgc21iaW5mb19T
T1VSQ0VTID0gc21iaW5mby5jCiByc3RfbWFuX3BhZ2VzICs9IHNtYmluZm8uMQogZW5kaWYKIAor
aWYgQ09ORklHX1BZVEhPTl9UT09MUworQ0xFQU5GSUxFUyArPSBzbWIycXVvdGEucnN0CitiaW5f
U0NSSVBUUyArPSBzbWIycXVvdGEKK2VuZGlmCisKIGlmIENPTkZJR19QTFVHSU4KIHBsdWdpbmRp
ciA9ICQocGtnbGliZGlyKQogcGx1Z2luX1BST0dSQU1TID0gaWRtYXB3Yi5zbwpkaWZmIC0tZ2l0
IGEvY29uZmlndXJlLmFjIGIvY29uZmlndXJlLmFjCmluZGV4IGNjNDg1NjMuLjFiMmM5YzkgMTAw
NjQ0Ci0tLSBhL2NvbmZpZ3VyZS5hYworKysgYi9jb25maWd1cmUuYWMKQEAgLTQ1LDYgKzQ1LDEx
IEBAIEFDX0FSR19FTkFCTEUoc21iaW5mbywKICAgICAgICAgZW5hYmxlX3NtYmluZm89JGVuYWJs
ZXZhbCwKICAgICAgICAgZW5hYmxlX3NtYmluZm89Im1heWJlIikKIAorQUNfQVJHX0VOQUJMRShw
eXRob250b29scywKKyAgICAgICAgW0FTX0hFTFBfU1RSSU5HKFstLWVuYWJsZS1weXRob250b29s
c10sW0luc3RhbGwgcHl0aG9uIHV0aWxpdGllcyBAPDpAZGVmYXVsdD15ZXNAQF0pXSwKKyAgICAg
ICAgZW5hYmxlX3B5dGhvbnRvb2xzPSRlbmFibGV2YWwsCisgICAgICAgIGVuYWJsZV9weXRob250
b29scz0ibWF5YmUiKQorCiBBQ19BUkdfRU5BQkxFKHBhbSwKIAlbQVNfSEVMUF9TVFJJTkcoWy0t
ZW5hYmxlLXBhbV0sW0NyZWF0ZSBjaWZzY3JlZHMgUEFNIG1vZHVsZSBAPDpAZGVmYXVsdD15ZXNA
Oj5AXSldLAogCWVuYWJsZV9wYW09JGVuYWJsZXZhbCwKQEAgLTI4MSw2ICsyODYsNyBAQCBBTV9D
T05ESVRJT05BTChDT05GSUdfQ0lGU0NSRURTLCBbdGVzdCAiJGVuYWJsZV9jaWZzY3JlZHMiICE9
ICJubyJdKQogQU1fQ09ORElUSU9OQUwoQ09ORklHX0NJRlNJRE1BUCwgW3Rlc3QgIiRlbmFibGVf
Y2lmc2lkbWFwIiAhPSAibm8iXSkKIEFNX0NPTkRJVElPTkFMKENPTkZJR19DSUZTQUNMLCBbdGVz
dCAiJGVuYWJsZV9jaWZzYWNsIiAhPSAibm8iXSkKIEFNX0NPTkRJVElPTkFMKENPTkZJR19TTUJJ
TkZPLCBbdGVzdCAiJGVuYWJsZV9zbWJpbmZvIiAhPSAibm8iXSkKK0FNX0NPTkRJVElPTkFMKENP
TkZJR19QWVRIT05fVE9PTFMsIFt0ZXN0ICIkZW5hYmxlX3B5dGhvbnRvb2xzIiAhPSAibm8iXSkK
IEFNX0NPTkRJVElPTkFMKENPTkZJR19QQU0sIFt0ZXN0ICIkZW5hYmxlX3BhbSIgIT0gIm5vIl0p
CiBBTV9DT05ESVRJT05BTChDT05GSUdfUExVR0lOLCBbdGVzdCAiJGVuYWJsZV9jaWZzaWRtYXAi
ICE9ICJubyIgLW8gIiRlbmFibGVfY2lmc2FjbCIgIT0gIm5vIl0pCiAKZGlmZiAtLWdpdCBhL3Nt
YjJxdW90YS5weSBiL3NtYjJxdW90YQpzaW1pbGFyaXR5IGluZGV4IDEwMCUKcmVuYW1lIGZyb20g
c21iMnF1b3RhLnB5CnJlbmFtZSB0byBzbWIycXVvdGEKLS0gCjIuMjEuMAoK
--000000000000e7033c05998b0654--
