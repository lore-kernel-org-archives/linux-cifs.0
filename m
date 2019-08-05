Return-Path: <SRS0=kH5s=WB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA69C433FF
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Aug 2019 22:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206D8208C3
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Aug 2019 22:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QDAqLcqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfHEWLX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Aug 2019 18:11:23 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:38430 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbfHEWLX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Aug 2019 18:11:23 -0400
Received: by mail-pg1-f173.google.com with SMTP id z14so3195221pga.5
        for <linux-cifs@vger.kernel.org>; Mon, 05 Aug 2019 15:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=avf0I3xDvtapHifqv/odAO+t6/BXw+LDG5CHHKSQoq4=;
        b=QDAqLcqhv7esoL7rA1LG8Uqe/qY/x+JLg09ZgAD7L14FfhH/WekeuyC+XJ4U8450TF
         mZKbFvcB9jrdgE4KaNECn8DlbA4dEzWRMPT/PYR3qSso7Lrg8Khyu3lXjDDST9Trp5oD
         Vr15+vW0+rk7Yc0+TBJsU942j3VnNfanbh0Vu2WLXimqOT9btITw+bIRNDv+9sbPjeTN
         3C8C63tHYJbSspiM5khBGiTMPMNQzrTn1qdYUrpA6+QddWTvpUHXH6VEir2BYTd5tymM
         pm+H+3NkYEAJf469EkVdX0ixZOcDVapcUeV8RlLznjyhj8EbpDyQoil7RCKyBSCjgmrv
         TY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=avf0I3xDvtapHifqv/odAO+t6/BXw+LDG5CHHKSQoq4=;
        b=NWpPZ4FFNq/RxE2zdmEnKgrknExe6xjfVOOaJaJPVFmgKnbzCLoIETrWB8BPUzuifc
         +k4SV0DaSrVBKc/i5PgqgdwFoxciz0Dol8URNIN1JO/K3n6tHWtMg3ELxBJMbgh4E6j0
         uS9NZhUOXzKwvU1sHdA7YjdnmYqPkVlkO0G7LK1HM/NC1QKmOpgsR5WODoiuKnucZiba
         xf78fxTa+eku6qHdis7MV8GL+GFVd4Un62UVSyGLoMdhKbbycn0gdWEQ68AmIyyEP3y9
         Q73koct7kBUOiX3ShJ1USkCZAApwg9WKmYF49OLOHHK30WUbhe+St3Lrs9nMZo0LsamA
         pdzA==
X-Gm-Message-State: APjAAAWSFa2oVZdr+IwWzL2BqkI7Ssej4pWOSXcnM2NsGiU52C+LrAr3
        LIjx+xbFrmRmmWYHJ3045pgdtgKVH9S6mCd3YHo=
X-Google-Smtp-Source: APXvYqz3nx9Jb8DUXXXh+/N2s4tZGjhMHRVJm0mLhX3wBoqKzYicOSSTBYqS0oUK8XqjZiro96urihe4cKfvZ54XDGk=
X-Received: by 2002:a63:724b:: with SMTP id c11mr125368pgn.30.1565043082327;
 Mon, 05 Aug 2019 15:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <e51f32ff-ce54-d015-4ba0-572ec35f3e45@samba.org> <a8102b82-046b-c62a-29c9-a61ae563bf34@samba.org>
In-Reply-To: <a8102b82-046b-c62a-29c9-a61ae563bf34@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 5 Aug 2019 17:11:11 -0500
Message-ID: <CAH2r5mvJzTmg+mPDeDcS7RJzdtYV4Coq76fKkVBu3oysU6ihkA@mail.gmail.com>
Subject: Re: [MS-SMB2] 2.2.3.1.4 SMB2_NETNAME_NEGOTIATE_CONTEXT_ID
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Steve French <stfrench@microsoft.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000fb2c65058f65fca1"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000fb2c65058f65fca1
Content-Type: text/plain; charset="UTF-8"

How about this fix?


On Fri, Jul 26, 2019 at 3:29 AM Stefan Metzmacher via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Hi Steve,
>
> I just contacted dochelp for this and noticed (from reading the code)
> that the kernel sends null-termination for the
> SMB2_NETNAME_NEGOTIATE_CONTEXT_ID value.
>
> I think you should fix that and backport it to stable releases,
> it would be good if all clients would implement it like windows.
>
> I implemented it for Samba here:
> https://gitlab.com/samba-team/samba/merge_requests/666
>
> metze
>
> Am 26.07.19 um 10:22 schrieb Stefan Metzmacher via cifs-protocol:
> > Hi DocHelp,
> >
> > I just noticed a documentation bug in
> > [MS-SMB2] 2.2.3.1.4 SMB2_NETNAME_NEGOTIATE_CONTEXT_ID:
> >
> >    NetName (variable): A null-terminated Unicode string containing the
> >    server name and specified by the client application.
> >
> > Windows Server 1903 sends the name without null-termination, see the
> > attached capture.
> >
> > metze
>
>


-- 
Thanks,

Steve

--000000000000fb2c65058f65fca1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Incorrect-size-for-netname-negotiate-context.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Incorrect-size-for-netname-negotiate-context.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jyyy8gf70>
X-Attachment-Id: f_jyyy8gf70

RnJvbSBmZDk3MjVlMThmOGM0MzZlMjI3NzgyMmVlZjAwMjViYWExZmU5YTJhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgNSBBdWcgMjAxOSAxNzowNzoyNiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IEluY29ycmVjdCBzaXplIGZvciBuZXRuYW1lIG5lZ290aWF0ZSBjb250ZXh0CgpJdCBpcyBu
b3QgbnVsbCB0ZXJtaW5hdGVkIChsZW5ndGggd2FzIG9mZiBieSB0d28pLgoKQWxzbyBzZWUgc2lt
aWxhciBjaGFuZ2UgdG8gU2FtYmE6CgpodHRwczovL2dpdGxhYi5jb20vc2FtYmEtdGVhbS9zYW1i
YS9tZXJnZV9yZXF1ZXN0cy82NjYKClJlcG9ydGVkLWJ5OiBTdGVmYW4gTWV0em1hY2hlciA8bWV0
emVAc2FtYmEub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jv
c29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCAzICstLQogMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21i
MnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggMzFlNGExYjBiMTcwLi41Y2MyYWIyZjJh
YzUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5j
CkBAIC01MDMsOCArNTAzLDcgQEAgYnVpbGRfbmV0bmFtZV9jdHh0KHN0cnVjdCBzbWIyX25ldG5h
bWVfbmVnX2NvbnRleHQgKnBuZWdfY3R4dCwgY2hhciAqaG9zdG5hbWUpCiAJcG5lZ19jdHh0LT5D
b250ZXh0VHlwZSA9IFNNQjJfTkVUTkFNRV9ORUdPVElBVEVfQ09OVEVYVF9JRDsKIAogCS8qIGNv
cHkgdXAgdG8gbWF4IG9mIGZpcnN0IDEwMCBieXRlcyBvZiBzZXJ2ZXIgbmFtZSB0byBOZXROYW1l
IGZpZWxkICovCi0JcG5lZ19jdHh0LT5EYXRhTGVuZ3RoID0gY3B1X3RvX2xlMTYoMiArCi0JCSgy
ICogY2lmc19zdHJ0b1VURjE2KHBuZWdfY3R4dC0+TmV0TmFtZSwgaG9zdG5hbWUsIDEwMCwgY3Ap
KSk7CisJcG5lZ19jdHh0LT5EYXRhTGVuZ3RoID0gY3B1X3RvX2xlMTYoMiAqIGNpZnNfc3RydG9V
VEYxNihwbmVnX2N0eHQtPk5ldE5hbWUsIGhvc3RuYW1lLCAxMDAsIGNwKSk7CiAJLyogY29udGV4
dCBzaXplIGlzIERhdGFMZW5ndGggKyBtaW5pbWFsIHNtYjJfbmVnX2NvbnRleHQgKi8KIAlyZXR1
cm4gRElWX1JPVU5EX1VQKGxlMTZfdG9fY3B1KHBuZWdfY3R4dC0+RGF0YUxlbmd0aCkgKwogCQkJ
c2l6ZW9mKHN0cnVjdCBzbWIyX25lZ19jb250ZXh0KSwgOCkgKiA4OwotLSAKMi4yMC4xCgo=
--000000000000fb2c65058f65fca1--
