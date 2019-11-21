Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA546C432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D29720672
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:41:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HpJqb7C6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKUTl6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 14:41:58 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36672 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUTl6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 14:41:58 -0500
Received: by mail-lj1-f193.google.com with SMTP id k15so4613905lja.3
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2019 11:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ELGt+qNlefKcXn/8ckMjiZXyCZbRnHmjfgugwVnZku0=;
        b=HpJqb7C6n2KWaPEsJaUqMFmysPLb4dzxXkdD/6yTXCFg79MxFHeDUuzKC2V5lwDm93
         3uRz7voIUI1E2P5VYomyVmeVum3DgdGd1FgQdQ+CoWCj9+ACo4Xj49dT+jx06x70BlBJ
         BE0JjAYFPF7/959c8u2b4DSiVy6j4vM6BCXGr2sIZt27qOSnAiO2IrDwL4Ar90k3wpvL
         llGpMT+tskCwZbpI99+LQduF1TuoVy1Nvb5u/VIXc9PXtEVlXZ9vQa/1Zej5mdqgk8H7
         hbfL8bjyjowRknSpcQL3wp/nwiCtzihdSVgWxQRljPAWEcPvtQOLxoToSEBNQbIwR+cO
         9MlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ELGt+qNlefKcXn/8ckMjiZXyCZbRnHmjfgugwVnZku0=;
        b=RjWQhlk5j9Ln8qOjm5lCndOMdrNk4mPVgYBoeG8wO+aqev14GORAU+MXY8tNyicEWc
         HfmU5QJ9wWTFZpx8RKGf3jcEKYwlLFxK9if4QeJZgDeBwkLyXmCKJASpcTAbYLvtq+nN
         V8YVnU21eZzuV0ZBNr5UCK9Zpkw0gUSSOWuM2CBPMFGxA4TaIga3zud5bks6qKlzVC/q
         Nx5N5SUXm8tN+fPmcbNIXWWxblhJ/tKvG4knxFjNswQNvPhotykwZbbYYnPX9+1iPtXm
         WgsHHqQDRQbkvjzQ08CrYylTFUr6GVeSnmIz4VQy97E95cZvf9pWB5exgaj/UmghMAqX
         A10g==
X-Gm-Message-State: APjAAAXAmGDz1BQn5UwrMRw331LoWZ+hlqm1/sBzcyvsKFq3W287LE03
        KDTiLDPmDTjfvO5OtG7INYlTOyY881licFyHjQ==
X-Google-Smtp-Source: APXvYqwb/Z6ij8XetfEUVuDbIv+j8nWdPL9lHNVL9myezvSHKRKwIYE3rcebYyDWtYDW5Ics0MJ5L8wUiTO2gWlWvxM=
X-Received: by 2002:a2e:760d:: with SMTP id r13mr8934637ljc.15.1574365315103;
 Thu, 21 Nov 2019 11:41:55 -0800 (PST)
MIME-Version: 1.0
References: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com>
 <CAKywueQ4nx2=V889Ty40QZOfoVij7Wp4dmhuhHV4A6mhGpgYAA@mail.gmail.com>
 <579288007.11441637.1573622351338.JavaMail.zimbra@redhat.com>
 <81694688.11451093.1573627786969.JavaMail.zimbra@redhat.com>
 <9195bac2-e271-537b-e1a0-8736efc80771@redhat.com> <1468784979.11678511.1573695584530.JavaMail.zimbra@redhat.com>
 <03640853-6710-00b9-735d-75acd947109f@redhat.com>
In-Reply-To: <03640853-6710-00b9-735d-75acd947109f@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 21 Nov 2019 11:41:43 -0800
Message-ID: <CAKywueR3GSog4kW28Boe8rbXDUbjdmf4s9OUgALF5851QLs8NA@mail.gmail.com>
Subject: Re: A process killed while opening a file can result in leaked open
 handle on the server
To:     Frank Sorenson <sorenson@redhat.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Frank,

I have just posted 3 patches to the list to address remaining handle leaks:

CIFS: Close open handle after interrupted close (2nd version of my
original patch to handle interrupted closes)
CIFS: Fix NULL pointer dereference in mid callback (not a handle leak
fix but the kernel kept crashing on my system during intensive testing
for handle leaks)
CIFS: Do not miss cancelled OPEN responses (fix to handle some
unmatched opens that are not processed right now due to races)

Could you please test them in your environment? I ran a script similar
to what you use for repro (just more iterations) and Samba didn't show
leaked handles afterwards.

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=81, 17 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 08:29, Frank=
 Sorenson <sorenson@redhat.com>:
>
> On 11/13/19 7:39 PM, Ronnie Sahlberg wrote:
> > ----- Original Message -----
> >> From: "Frank Sorenson" <sorenson@redhat.com>
> >> To: "Ronnie Sahlberg" <lsahlber@redhat.com>, "Pavel Shilovsky" <piastr=
yyy@gmail.com>
> >> Cc: "linux-cifs" <linux-cifs@vger.kernel.org>
> >> Sent: Thursday, 14 November, 2019 8:15:46 AM
> >> Subject: Re: A process killed while opening a file can result in leake=
d open handle on the server
> >>
> >> On 11/13/19 12:49 AM, Ronnie Sahlberg wrote:
> >>> Steve, Pavel
> >>>
> >>> This patch goes ontop of Pavels patch.
> >>> Maybe it should be merged with Pavels patch since his patch changes f=
rom
> >>> "we only send a close() on an interrupted open()"
> >>> to now "we send a close() on either interrupted open() or interrupted
> >>> close()" so both comments as well as log messages are updates.
> >>>
> >>> Additionally it adds logging of the MID that failed in the case of an
> >>> interrupted Open() so that it is easy to find it in wireshark
> >>> and check whether that smb2 file handle was indeed handles by a SMB_C=
lose()
> >>> or not.
> >>>
> >>>
> >>> From testing it appears Pavels patch works. When the close() is inter=
rupted
> >>> we don't leak handles as far as I can tell.
> >>> We do have a leak in the Open() case though and it seems that eventho=
ugh we
> >>> set things up and flags the MID to be cancelled we actually never end=
 up
> >>> calling smb2_cancelled_close_fid() and thus we never send a SMB2_Clos=
e().
> >>> I haven't found the root cause yet but I suspect we mess up mid flags=
 or
> >>> state somewhere.
> >>>
> >>>
> >>> It did work in the past though when Sachin provided the initial
> >>> implementation so we have regressed I think.
> >>> I have added a new test 'cifs/102'  to the buildbot that checks for t=
his
> >>> but have not integrated into the cifs-testing run yet since we still =
fail
> >>> this test.
> >>> At least we will not have further regressions once we fix this and en=
able
> >>> the test in the future.
> >>>
> >>> ronnie s
> >>
> >> The patches do indeed improve it significantly.
> >>
> >> I'm still seeing some leak as well, and I'm removing ratelimiting so
> >> that I can see what the added debugging is trying to tell us.  I'll
> >> report if I find more details.
>
> > We are making progress.
>
> Agreed.  We're definitely making progress.
>
> > Can you test this patch if it improves even more for you?
> > It fixes most but not all the leaks I see for interrupted open():
> >
> > I will post this to the list too as a separate mail/patch.
>
>
> Sorry to be slow on the testing.
>
>
> I might be seeing some small improvement with this one, but I'm still see=
ing some mismatches:
>
> # for i in {1..100} ; do cat /mnt/vm3/foo.$i >/dev/null 2>&1 & sleep 0.00=
01 ; kill -9 $! ; done
> ...
>
> This ended up with 2 open on the server side:
>
> 21842        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)     =
  /home/user1   foo.32   Sun Nov 17 09:13:38 2019
> 21842        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)     =
  /home/user1   foo.48   Sun Nov 17 09:13:38 2019
>
>
> the packet capture shows the same mismatch pattern for these two:
>
> 102  Create Request File: foo.32;GetInfo Request FILE_INFO/SMB2_FILE_ALL_=
INFO;Close Request
> 103  Create Response File: foo.32;GetInfo Response;Close Response
> 104  Create Request File: foo.32
> 105  Create Response File: foo.32
>
>
> 148  Create Request File: foo.48;GetInfo Request FILE_INFO/SMB2_FILE_ALL_=
INFO;Close Request
> 149  Create Response File: foo.48;GetInfo Response;Close Response
> 150  Create Request File: foo.48
> 151  Create Response File: foo.48
>
> with no close for those two.
>
>
> the messages are also similar, and show transmitting the second open requ=
est and cancelling the wait immediately afterward:
> [9006] cifs:cifs_lookup:669: fs/cifs/dir.c: CIFS VFS: in cifs_lookup as X=
id: 1091 with uid: 0
> [9006] cifs:cifs_lookup:672: fs/cifs/dir.c: parent inode =3D 0x000000008f=
9424fe name is: foo.32 and dentry =3D 0x0000000053e436bf
> [9006] cifs:build_path_from_dentry_optional_prefix:143: fs/cifs/dir.c: na=
me: \foo.32
> [9006] cifs:cifs_lookup:704: fs/cifs/dir.c: NULL inode in lookup
> [9006] cifs:cifs_lookup:707: fs/cifs/dir.c: Full path: \foo.32 inode =3D =
0x000000004667ea0b
> [9006] cifs:cifs_get_inode_info:753: fs/cifs/inode.c: Getting info on \fo=
o.32
> [9006] cifs:__smb_send_rqst:368: fs/cifs/transport.c: Sending smb: smb_le=
n=3D356
> [9006] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_=
result: cmd=3D5 mid=3D113 state=3D4
> [9006] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_=
result: cmd=3D16 mid=3D114 state=3D4
> [9006] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_=
result: cmd=3D6 mid=3D115 state=3D4
> [9006] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passe=
d to cifs_small_buf_release
> [9006] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passe=
d to cifs_small_buf_release
> [9006] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passe=
d to cifs_small_buf_release
> [9006] cifs:cifs_iget:1030: fs/cifs/inode.c: looking for uniqueid=3D59349=
09
> [9006] cifs:cifs_revalidate_cache:100: fs/cifs/inode.c: cifs_revalidate_c=
ache: revalidating inode 5934909
> [9006] cifs:cifs_revalidate_cache:124: fs/cifs/inode.c: cifs_revalidate_c=
ache: invalidating inode 5934909 mapping
> [9006] cifs:cifs_lookup:734: fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup=
 (xid =3D 1091) rc =3D 0
> [9006] cifs:cifs_open:512: fs/cifs/file.c: CIFS VFS: in cifs_open as Xid:=
 1092 with uid: 0
> [9006] cifs:build_path_from_dentry_optional_prefix:143: fs/cifs/dir.c: na=
me: \foo.32
> [9006] cifs:cifs_open:530: fs/cifs/file.c: inode =3D 0x000000001a16a2ae f=
ile flags are 0x8000 for \foo.32
> [9006] cifs:SMB2_open:2581: fs/cifs/smb2pdu.c: create/open
> [9006] cifs:__smb_send_rqst:368: fs/cifs/transport.c: Sending smb: smb_le=
n=3D284
> CIFS VFS: \\vm3 Cancelling wait for mid 116 cmd: 5
> [9006] cifs:cifs_open:618: fs/cifs/file.c: CIFS VFS: leaving cifs_open (x=
id =3D 1092) rc =3D -512
>
>
>
> [9039] cifs:cifs_lookup:669: fs/cifs/dir.c: CIFS VFS: in cifs_lookup as X=
id: 1109 with uid: 0
> [9039] cifs:cifs_lookup:672: fs/cifs/dir.c: parent inode =3D 0x000000008f=
9424fe name is: foo.48 and dentry =3D 0x0000000040aea0d9
> [9039] cifs:build_path_from_dentry_optional_prefix:143: fs/cifs/dir.c: na=
me: \foo.48
> [9039] cifs:cifs_lookup:704: fs/cifs/dir.c: NULL inode in lookup
> [9039] cifs:cifs_lookup:707: fs/cifs/dir.c: Full path: \foo.48 inode =3D =
0x000000004667ea0b
> [9039] cifs:cifs_get_inode_info:753: fs/cifs/inode.c: Getting info on \fo=
o.48
> [9039] cifs:__smb_send_rqst:368: fs/cifs/transport.c: Sending smb: smb_le=
n=3D356
> [9039] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_=
result: cmd=3D5 mid=3D158 state=3D4
> [9039] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_=
result: cmd=3D16 mid=3D159 state=3D4
> [9039] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_=
result: cmd=3D6 mid=3D160 state=3D4
> [9039] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passe=
d to cifs_small_buf_release
> [9039] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passe=
d to cifs_small_buf_release
> [9039] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passe=
d to cifs_small_buf_release
> [9039] cifs:cifs_iget:1030: fs/cifs/inode.c: looking for uniqueid=3D21857=
488
> [9039] cifs:cifs_revalidate_cache:100: fs/cifs/inode.c: cifs_revalidate_c=
ache: revalidating inode 21857488
> [9039] cifs:cifs_revalidate_cache:124: fs/cifs/inode.c: cifs_revalidate_c=
ache: invalidating inode 21857488 mapping
> [9039] cifs:cifs_lookup:734: fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup=
 (xid =3D 1109) rc =3D 0
> [9039] cifs:cifs_open:512: fs/cifs/file.c: CIFS VFS: in cifs_open as Xid:=
 1110 with uid: 0
> [9039] cifs:build_path_from_dentry_optional_prefix:143: fs/cifs/dir.c: na=
me: \foo.48
> [9039] cifs:cifs_open:530: fs/cifs/file.c: inode =3D 0x00000000001a4f79 f=
ile flags are 0x8000 for \foo.48
> [9039] cifs:SMB2_open:2581: fs/cifs/smb2pdu.c: create/open
> [9039] cifs:__smb_send_rqst:368: fs/cifs/transport.c: Sending smb: smb_le=
n=3D284
> CIFS VFS: \\vm3 Cancelling wait for mid 161 cmd: 5
> [9039] cifs:cifs_open:618: fs/cifs/file.c: CIFS VFS: leaving cifs_open (x=
id =3D 1110) rc =3D -512
>
>
> Frank
>
