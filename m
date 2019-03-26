Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BB8C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 18:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B49A20823
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 18:54:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eeXHzv/t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbfCZSyt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 14:54:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42455 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfCZSyt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Mar 2019 14:54:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id r15so8478132pfn.9
        for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2019 11:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UwCLeWkzRjBUcLv+QXvKfLOx6xrdZnJF2j9Rj3Gdfjk=;
        b=eeXHzv/tlBEtLbv93lnFLkHxtr0ou/JU1KUHqSRNpSk+OlVHDvYzJ2BwMuS2UF3l26
         fGjodcEHI3tdWww2bWodkqKxOUuwkfEh5qmh1wtBpmCk0/A44PN3HRNRPT57F4ipKiUE
         5EqJtknA40Ms72lvzYh/Kr5CF9NC+4qgeY5yIk5ltqer3qTR+26HjcW8NVcbxPnPuUdC
         9chkr+MjqO3iJc1wGfnghkMbLM+hyUW//ha8z3e9oJCupygoX+pgRyvnrXC5kXRDC/9P
         saLZmiSHKUUL5AQrgIX/YgYWFW9+DIj54//cEwu/kQbEobNDWLbjSyZ3UfTQ7M4MZk9c
         9cdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UwCLeWkzRjBUcLv+QXvKfLOx6xrdZnJF2j9Rj3Gdfjk=;
        b=d++LlLuaoaC5reP0Cn3MD1mVBCiUX3/oMkz5rjrnz0GzXeJM5AxDG30inZUh3cJhGp
         rt+L/k+fP5/NjY6gwuBRgz8oE+7cBAyukbZJd5DML5kaDQDS5GM15BHSoZVnoTjEOJxk
         pVz/Rp8qUMc2mNN2UaqvQey/VLojkAfmwK/dANyGBEtJ3ve+0Z0tEbf+NltOKuBfdvdH
         igbDVftaK7JLqYva6jj2cUy5FMuk7XiJATKlR5Oa7sjlxm0sp0C5npNHxk5wny7YDDhW
         UggYC/TFpcd9jDLTqEZxnSfhpGz08PgznughLXgVousLt2yfvI1VM0xpWqgpCQUVZzia
         MpfA==
X-Gm-Message-State: APjAAAV9+oHUw+lb3DZXI50pEqysMuwWgj3WRXFdkh0v76nPVl1MIgmc
        0g2Mb8gi9HsnuGYPCCiaZfQ2V9Ghvrut0vg8ENY=
X-Google-Smtp-Source: APXvYqxYXlM3ijrei4XP1LhBthCIEPS+MYCNfk+uDD+yoF7hA+ISFMLvfQ5ivP93e9ryPyihODQyYJXDojSotZoqB80=
X-Received: by 2002:a62:1c8d:: with SMTP id c135mr31655236pfc.255.1553626488152;
 Tue, 26 Mar 2019 11:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms+oJ8PpAbsmTmRDqoS4C=dcNV=xYv3tMWnoigA5JqFsA@mail.gmail.com>
 <CAN05THRYrWBi9cSB5-gbV_y9cAf+0KTPn-2ogPc7SU2t9ob6UQ@mail.gmail.com>
In-Reply-To: <CAN05THRYrWBi9cSB5-gbV_y9cAf+0KTPn-2ogPc7SU2t9ob6UQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 26 Mar 2019 13:54:36 -0500
Message-ID: <CAH2r5mt4yFse7kmR2Oe6wWSrGCVO2aq=PF2iiC7kYJSY3e7xtA@mail.gmail.com>
Subject: Re: [RFC][PATCH] Track time spent in each command
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000f0c628058503da20"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f0c628058503da20
Content-Type: text/plain; charset="UTF-8"

How about this updated patch - note how I now display min/max
(although min in this case will always be zero since jiffies are
pretty coarse granularity - maybe would be more helpful to run this
example over a slow link, or I could just make the patch simpler and
not save the minimum time for each command).  Note that the new stats
begin with the line "Total time spent processing by command ..."




$ cat /proc/fs/cifs/Stats
Resources in use
CIFS Session: 1
Share (unique mount targets): 3
SMB Request/Response Buffer: 1 Pool size: 5
SMB Small Req/Resp Buffer: 1 Pool size: 30
Total Large 38854 Small 1039857 Allocations
Operations (MIDs): 0

0 session 0 share reconnects
Total vfs operations: 272653 maximum at one time: 3

Total time spent processing by command. Time units are jiffies (250 per second)
  SMB3 CMD    Number    Total Time    Fastest    Slowest
  --------    ------    ----------    -------    -------
  0        1    1        1    1
  1        2    1        0    1
  2        0    0        0    0
  3        6    1        0    1
  4        3    0        0    0
  5        95353    5163        0    12
  6        95314    3012        0    1
  7        2    2        1    1
  8        4263    57        0    1
  9        1101    33        0    1
  10        0    0        0    0
  11        16    0        0    0
  12        0    0        0    0
  13        0    0        0    0
  14        121    37        0    1
  15        0    0        0    0
  16        56357    1100        0    1
  17        16703    1089        0    1
  18        0    0        0    0

1) \\localhost\btrfs-scratch
SMBs: 72
Bytes read: 0  Bytes written: 210729
Open files: 1 total (local), 2 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 21 total 2 failed
Closes: 15 total 0 failed
Flushes: 0 total 0 failed
Reads: 0 total 0 failed
Writes: 11 total 0 failed
Locks: 0 total 0 failed
IOCTLs: 2 total 1 failed
QueryDirectories: 0 total 0 failed
ChangeNotifies: 0 total 0 failed
QueryInfos: 22 total 1 failed
SetInfos: 0 total 0 failed
OplockBreaks: 0 sent 0 failed
2) \\localhost\btrfs
SMBs: 269059
Bytes read: 115059522  Bytes written: 87813235
Open files: 0 total (local), 0 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 95304 total 14 failed
Closes: 95277 total 0 failed
Flushes: 2 total 0 failed
Reads: 4263 total 0 failed
Writes: 1090 total 0 failed
Locks: 0 total 0 failed
IOCTLs: 2 total 1 failed
QueryDirectories: 117 total 0 failed
ChangeNotifies: 0 total 0 failed
QueryInfos: 56300 total 0 failed
SetInfos: 16703 total 0 failed
OplockBreaks: 0 sent 0 failed


On Tue, Mar 26, 2019 at 1:38 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Very nice.
> But maybe min and max to each command as well.
> I have all three of min/max/avg is very useful.
>
> At least avg and max will tell you if there are any abnormal outliers.
>
> On Tue, Mar 26, 2019 at 3:39 PM Steve French <smfrench@gmail.com> wrote:
> >
> > I created a small experimental patch (leveraging the existing code for
> > the slow command check we already have in mid processing) to track the
> > total time per SMB2/SMB3 command.   Seems like it could be useful -
> > here is sample output (see below) from running seven xfstests to
> > generate the stats (these stats require CONFIG_CIFS_STATS2 to be
> > compiled as do the slow command counters).   I wanted to keep the
> > patch small and low risk so this seemed like the best place to capture
> > it.    This could be helpful in calculating average time per command
> > (and perhaps help isolate performance problems, and isolate what is
> > really causing slowdowns).   As with other counters: "echo 0 >
> > /proc/fs/cifs/Stats" resets them.   The new stats counters start at
> > the line "Total time spent processing each command"
> >
> > Thoughts?
> >
> > $ cat /proc/fs/cifs/Stats
> > Resources in use
> > CIFS Session: 1
> > Share (unique mount targets): 3
> > SMB Request/Response Buffer: 1 Pool size: 5
> > SMB Small Req/Resp Buffer: 2 Pool size: 30
> > Total Large 60864 Small 1165977 Allocations
> > Operations (MIDs): 1
> >
> > 0 session 0 share reconnects
> > Total vfs operations: 280236 maximum at one time: 3
> > Total time spent processing each command
> > cmd: 0 jiffies: 0 seconds 0
> > cmd: 1 jiffies: 2 seconds 0
> > cmd: 2 jiffies: 0 seconds 0
> > cmd: 3 jiffies: 1 seconds 0
> > cmd: 4 jiffies: 1 seconds 0
> > cmd: 5 jiffies: 6212 seconds 24
> > cmd: 6 jiffies: 3993 seconds 15
> > cmd: 7 jiffies: 135 seconds 0
> > cmd: 8 jiffies: 83 seconds 0
> > cmd: 9 jiffies: 44 seconds 0
> > cmd: 10 jiffies: 0 seconds 0
> > cmd: 11 jiffies: 1 seconds 0
> > cmd: 12 jiffies: 0 seconds 0
> > cmd: 13 jiffies: 0 seconds 0
> > cmd: 14 jiffies: 47 seconds 0
> > cmd: 15 jiffies: 0 seconds 0
> > cmd: 16 jiffies: 1890 seconds 7
> > cmd: 17 jiffies: 1368 seconds 5
> > cmd: 18 jiffies: 0 seconds 0
> >
> > 1) \\localhost\btrfs-scratch
> > SMBs: 42255
> > Bytes read: 25379425  Bytes written: 53689661
> > Open files: 1 total (local), 1 open on server
> > TreeConnects: 1 total 0 failed
> > TreeDisconnects: 0 total 0 failed
> > Creates: 14012 total 0 failed
> > Closes: 14009 total 0 failed
> > Flushes: 27 total 0 failed
> > Reads: 41 total 0 failed
> > Writes: 112 total 0 failed
> > Locks: 0 total 0 failed
> > IOCTLs: 2 total 1 failed
> > QueryDirectories: 28 total 0 failed
> > ChangeNotifies: 0 total 0 failed
> > QueryInfos: 11312 total 0 failed
> > SetInfos: 2711 total 0 failed
> > OplockBreaks: 0 sent 0 failed
> > 2) \\localhost\btrfs
> > SMBs: 77
> > Bytes read: 282  Bytes written: 94
> > Open files: 0 total (local), 0 open on server
> > TreeConnects: 1 total 0 failed
> > TreeDisconnects: 0 total 0 failed
> > Creates: 23 total 0 failed
> > Closes: 21 total 0 failed
> > Flushes: 0 total 0 failed
> > Reads: 3 total 0 failed
> > Writes: 1 total 0 failed
> > Locks: 0 total 0 failed
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve

--000000000000f0c628058503da20
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Track-total-time-spent-on-roundtrips-for-each-S.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Track-total-time-spent-on-roundtrips-for-each-S.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jtq537ls0>
X-Attachment-Id: f_jtq537ls0

RnJvbSAzMzM3NDYxYTk0MzM4MDhhYmFjZGFlNzUxZGY4YzE3YmVmMTcyMzhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjYgTWFyIDIwMTkgMTM6NTM6MjEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBUcmFjayB0b3RhbCB0aW1lIHNwZW50IG9uIHJvdW5kdHJpcHMgZm9yIGVhY2ggU01CMwog
Y29tbWFuZAoKQWxzbyB0cmFjayBtaW5pbXVtIGFuZCBtYXhpbXVtIHRpbWUgYnkgY29tbWFuZCBp
biAvcHJvYy9mcy9jaWZzL1N0YXRzCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJl
bmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzX2RlYnVnLmMgfCAxOSArKysrKysr
KysrKysrKysrKy0tCiBmcy9jaWZzL2NpZnNnbG9iLmggICB8ICA0ICsrKysKIGZzL2NpZnMvdHJh
bnNwb3J0LmMgIHwgMjcgKysrKysrKysrKysrKysrKysrKysrKystLS0tCiAzIGZpbGVzIGNoYW5n
ZWQsIDQ0IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9jaWZzX2RlYnVnLmMgYi9mcy9jaWZzL2NpZnNfZGVidWcuYwppbmRleCAxM2MxMjg4YjA0YTcu
LjE5ZWQ5YWJlMDBkZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzX2RlYnVnLmMKKysrIGIvZnMv
Y2lmcy9jaWZzX2RlYnVnLmMKQEAgLTQ2Miw4ICs0NjIsMTMgQEAgc3RhdGljIHNzaXplX3QgY2lm
c19zdGF0c19wcm9jX3dyaXRlKHN0cnVjdCBmaWxlICpmaWxlLAogCQkJc2VydmVyID0gbGlzdF9l
bnRyeSh0bXAxLCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvLAogCQkJCQkgICAgdGNwX3Nlc19saXN0
KTsKICNpZmRlZiBDT05GSUdfQ0lGU19TVEFUUzIKLQkJCWZvciAoaSA9IDA7IGkgPCBOVU1CRVJf
T0ZfU01CMl9DT01NQU5EUzsgaSsrKQorCQkJZm9yIChpID0gMDsgaSA8IE5VTUJFUl9PRl9TTUIy
X0NPTU1BTkRTOyBpKyspIHsKKwkJCQlhdG9taWNfc2V0KCZzZXJ2ZXItPm51bV9jbWRzW2ldLCAw
KTsKIAkJCQlhdG9taWNfc2V0KCZzZXJ2ZXItPnNtYjJzbG93Y21kW2ldLCAwKTsKKwkJCQlzZXJ2
ZXItPnRpbWVfcGVyX2NtZFtpXSA9IDA7CisJCQkJc2VydmVyLT5zbG93ZXN0X2NtZFtpXSA9IDA7
CisJCQkJc2VydmVyLT5mYXN0ZXN0X2NtZFswXSA9IDA7CisJCQl9CiAjZW5kaWYgLyogQ09ORklH
X0NJRlNfU1RBVFMyICovCiAJCQlsaXN0X2Zvcl9lYWNoKHRtcDIsICZzZXJ2ZXItPnNtYl9zZXNf
bGlzdCkgewogCQkJCXNlcyA9IGxpc3RfZW50cnkodG1wMiwgc3RydWN0IGNpZnNfc2VzLApAQCAt
NTMxLDkgKzUzNiwxOSBAQCBzdGF0aWMgaW50IGNpZnNfc3RhdHNfcHJvY19zaG93KHN0cnVjdCBz
ZXFfZmlsZSAqbSwgdm9pZCAqdikKIAkJc2VydmVyID0gbGlzdF9lbnRyeSh0bXAxLCBzdHJ1Y3Qg
VENQX1NlcnZlcl9JbmZvLAogCQkJCSAgICB0Y3Bfc2VzX2xpc3QpOwogI2lmZGVmIENPTkZJR19D
SUZTX1NUQVRTMgorCQlzZXFfcHV0cyhtLCAiXG5Ub3RhbCB0aW1lIHNwZW50IHByb2Nlc3Npbmcg
YnkgY29tbWFuZC4gVGltZSAiKTsKKwkJc2VxX3ByaW50ZihtLCAidW5pdHMgYXJlIGppZmZpZXMg
KCVkIHBlciBzZWNvbmQpXG4iLCBIWik7CisJCXNlcV9wdXRzKG0sICIgIFNNQjMgQ01EXHROdW1i
ZXJcdFRvdGFsIFRpbWVcdEZhc3Rlc3RcdFNsb3dlc3RcbiIpOworCQlzZXFfcHV0cyhtLCAiICAt
LS0tLS0tLVx0LS0tLS0tXHQtLS0tLS0tLS0tXHQtLS0tLS0tXHQtLS0tLS0tXG4iKTsKKwkJZm9y
IChqID0gMDsgaiA8IE5VTUJFUl9PRl9TTUIyX0NPTU1BTkRTOyBqKyspCisJCQlzZXFfcHJpbnRm
KG0sICIgICVkXHRcdCVkXHQlbGx1XHRcdCV1XHQldVxuIiwgaiwKKwkJCQlhdG9taWNfcmVhZCgm
c2VydmVyLT5udW1fY21kc1tqXSksCisJCQkJc2VydmVyLT50aW1lX3Blcl9jbWRbal0sCisJCQkJ
c2VydmVyLT5mYXN0ZXN0X2NtZFtqXSwKKwkJCQlzZXJ2ZXItPnNsb3dlc3RfY21kW2pdKTsKIAkJ
Zm9yIChqID0gMDsgaiA8IE5VTUJFUl9PRl9TTUIyX0NPTU1BTkRTOyBqKyspCiAJCQlpZiAoYXRv
bWljX3JlYWQoJnNlcnZlci0+c21iMnNsb3djbWRbal0pKQotCQkJCXNlcV9wcmludGYobSwgIiVk
IHNsb3cgcmVzcG9uc2VzIGZyb20gJXMgZm9yIGNvbW1hbmQgJWRcbiIsCisJCQkJc2VxX3ByaW50
ZihtLCAiICAlZCBzbG93IHJlc3BvbnNlcyBmcm9tICVzIGZvciBjb21tYW5kICVkXG4iLAogCQkJ
CQlhdG9taWNfcmVhZCgmc2VydmVyLT5zbWIyc2xvd2NtZFtqXSksCiAJCQkJCXNlcnZlci0+aG9z
dG5hbWUsIGopOwogI2VuZGlmIC8qIFNUQVRTMiAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZz
Z2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IDI1NmNkNDhmYjRjNy4uMzk1YTRlM2U4
MmNkIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9jaWZzZ2xv
Yi5oCkBAIC03MDcsNyArNzA3LDExIEBAIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gewogI2lmZGVm
IENPTkZJR19DSUZTX1NUQVRTMgogCWF0b21pY190IGluX3NlbmQ7IC8qIHJlcXVlc3RzIHRyeWlu
ZyB0byBzZW5kICovCiAJYXRvbWljX3QgbnVtX3dhaXRlcnM7ICAgLyogYmxvY2tlZCB3YWl0aW5n
IHRvIGdldCBpbiBzZW5kcmVjdiAqLworCWF0b21pY190IG51bV9jbWRzW05VTUJFUl9PRl9TTUIy
X0NPTU1BTkRTXTsgLyogdG90YWwgcmVxdWVzdHMgYnkgY21kICovCiAJYXRvbWljX3Qgc21iMnNs
b3djbWRbTlVNQkVSX09GX1NNQjJfQ09NTUFORFNdOyAvKiBjb3VudCByZXNwcyA+IDEgc2VjICov
CisJX191NjQgdGltZV9wZXJfY21kW05VTUJFUl9PRl9TTUIyX0NPTU1BTkRTXTsgLyogdG90YWwg
dGltZSBwZXIgY21kICovCisJX191MzIgc2xvd2VzdF9jbWRbTlVNQkVSX09GX1NNQjJfQ09NTUFO
RFNdOworCV9fdTMyIGZhc3Rlc3RfY21kW05VTUJFUl9PRl9TTUIyX0NPTU1BTkRTXTsKICNlbmRp
ZiAvKiBTVEFUUzIgKi8KIAl1bnNpZ25lZCBpbnQJbWF4X3JlYWQ7CiAJdW5zaWduZWQgaW50CW1h
eF93cml0ZTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJhbnNwb3J0LmMgYi9mcy9jaWZzL3RyYW5z
cG9ydC5jCmluZGV4IDFkZThlOTk2ZTU2Ni4uNjVkOWYzZTJlYjg4IDEwMDY0NAotLS0gYS9mcy9j
aWZzL3RyYW5zcG9ydC5jCisrKyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMKQEAgLTEwNCw3ICsxMDQs
MTAgQEAgRGVsZXRlTWlkUUVudHJ5KHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkRW50cnkpCiB7CiAj
aWZkZWYgQ09ORklHX0NJRlNfU1RBVFMyCiAJX19sZTE2IGNvbW1hbmQgPSBtaWRFbnRyeS0+c2Vy
dmVyLT52YWxzLT5sb2NrX2NtZDsKKwlfX3UxNiBzbWJfY21kID0gbGUxNl90b19jcHUobWlkRW50
cnktPmNvbW1hbmQpOwogCXVuc2lnbmVkIGxvbmcgbm93OworCXVuc2lnbmVkIGxvbmcgcm91bmR0
cmlwX3RpbWU7CisJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyID0gbWlkRW50cnktPnNl
cnZlcjsKICNlbmRpZgogCW1pZEVudHJ5LT5taWRfc3RhdGUgPSBNSURfRlJFRTsKIAlhdG9taWNf
ZGVjKCZtaWRDb3VudCk7CkBAIC0xMTQsNiArMTE3LDIzIEBAIERlbGV0ZU1pZFFFbnRyeShzdHJ1
Y3QgbWlkX3FfZW50cnkgKm1pZEVudHJ5KQogCQljaWZzX3NtYWxsX2J1Zl9yZWxlYXNlKG1pZEVu
dHJ5LT5yZXNwX2J1Zik7CiAjaWZkZWYgQ09ORklHX0NJRlNfU1RBVFMyCiAJbm93ID0gamlmZmll
czsKKwlpZiAobm93IDwgbWlkRW50cnktPndoZW5fYWxsb2MpCisJCWNpZnNfZGJnKFZGUywgImlu
dmFsaWQgbWlkIGFsbG9jYXRpb24gdGltZVxuIik7CisJcm91bmR0cmlwX3RpbWUgPSBub3cgLSBt
aWRFbnRyeS0+d2hlbl9hbGxvYzsKKworCWlmIChzbWJfY21kIDwgTlVNQkVSX09GX1NNQjJfQ09N
TUFORFMpIHsKKwkJaWYgKGF0b21pY19yZWFkKCZzZXJ2ZXItPm51bV9jbWRzW3NtYl9jbWRdKSA9
PSAwKSB7CisJCQlzZXJ2ZXItPnNsb3dlc3RfY21kW3NtYl9jbWRdID0gcm91bmR0cmlwX3RpbWU7
CisJCQlzZXJ2ZXItPmZhc3Rlc3RfY21kW3NtYl9jbWRdID0gcm91bmR0cmlwX3RpbWU7CisJCX0g
ZWxzZSB7CisJCQlpZiAoc2VydmVyLT5zbG93ZXN0X2NtZFtzbWJfY21kXSA8IHJvdW5kdHJpcF90
aW1lKQorCQkJCXNlcnZlci0+c2xvd2VzdF9jbWRbc21iX2NtZF0gPSByb3VuZHRyaXBfdGltZTsK
KwkJCWVsc2UgaWYgKHNlcnZlci0+ZmFzdGVzdF9jbWRbc21iX2NtZF0gPiByb3VuZHRyaXBfdGlt
ZSkKKwkJCQlzZXJ2ZXItPmZhc3Rlc3RfY21kW3NtYl9jbWRdID0gcm91bmR0cmlwX3RpbWU7CisJ
CX0KKwkJY2lmc19zdGF0c19pbmMoJnNlcnZlci0+bnVtX2NtZHNbc21iX2NtZF0pOworCQlzZXJ2
ZXItPnRpbWVfcGVyX2NtZFtzbWJfY21kXSArPSByb3VuZHRyaXBfdGltZTsKKwl9CiAJLyoKIAkg
KiBjb21tYW5kcyB0YWtpbmcgbG9uZ2VyIHRoYW4gb25lIHNlY29uZCAoZGVmYXVsdCkgY2FuIGJl
IGluZGljYXRpb25zCiAJICogdGhhdCBzb21ldGhpbmcgaXMgd3JvbmcsIHVubGVzcyBpdCBpcyBx
dWl0ZSBhIHNsb3cgbGluayBvciBhIHZlcnkKQEAgLTEzMSwxMSArMTUxLDEwIEBAIERlbGV0ZU1p
ZFFFbnRyeShzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZEVudHJ5KQogCQkgKiBzbWIyc2xvd2NtZFtO
VU1CRVJfT0ZfU01CMl9DT01NQU5EU10gY291bnRzIGJ5IGNvbW1hbmQKIAkJICogTkI6IGxlMTZf
dG9fY3B1IHJldHVybnMgdW5zaWduZWQgc28gY2FuIG5vdCBiZSBuZWdhdGl2ZSBiZWxvdwogCQkg
Ki8KLQkJaWYgKGxlMTZfdG9fY3B1KG1pZEVudHJ5LT5jb21tYW5kKSA8IE5VTUJFUl9PRl9TTUIy
X0NPTU1BTkRTKQotCQkJY2lmc19zdGF0c19pbmMoJm1pZEVudHJ5LT5zZXJ2ZXItPnNtYjJzbG93
Y21kW2xlMTZfdG9fY3B1KG1pZEVudHJ5LT5jb21tYW5kKV0pOworCQlpZiAoc21iX2NtZCA8IE5V
TUJFUl9PRl9TTUIyX0NPTU1BTkRTKQorCQkJY2lmc19zdGF0c19pbmMoJnNlcnZlci0+c21iMnNs
b3djbWRbc21iX2NtZF0pOwogCi0JCXRyYWNlX3NtYjNfc2xvd19yc3AobGUxNl90b19jcHUobWlk
RW50cnktPmNvbW1hbmQpLAotCQkJICAgICAgIG1pZEVudHJ5LT5taWQsIG1pZEVudHJ5LT5waWQs
CisJCXRyYWNlX3NtYjNfc2xvd19yc3Aoc21iX2NtZCwgbWlkRW50cnktPm1pZCwgbWlkRW50cnkt
PnBpZCwKIAkJCSAgICAgICBtaWRFbnRyeS0+d2hlbl9zZW50LCBtaWRFbnRyeS0+d2hlbl9yZWNl
aXZlZCk7CiAJCWlmIChjaWZzRllJICYgQ0lGU19USU1FUikgewogCQkJcHJfZGVidWcoIiBDSUZT
IHNsb3cgcnNwOiBjbWQgJWQgbWlkICVsbHUiLAotLSAKMi4xNy4xCgo=
--000000000000f0c628058503da20--
