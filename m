Return-Path: <SRS0=RDsd=ZJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C98D7C432C0
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Nov 2019 16:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83BD220730
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Nov 2019 16:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKtSRymP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfKQQ3f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Nov 2019 11:29:35 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23252 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726069AbfKQQ3e (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 17 Nov 2019 11:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574008172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KcZvuoxD+un/PoZmjhfu0WaOYC6qYUbEmKkXl1AhIm0=;
        b=BKtSRymPb74OIJPX8Umcazf0HYb9ktcLpai7NIPnygFWO0QP95cPY6XKpZr7CI/L0iWB4u
        N7GeG5IVFktcoeTc4vV9z9PGreqC869GhQhTFhsLGk5S4Ey/O2jUA4jZcnCB+jsTLVCufL
        vGI1AasDY++pYe0lFrvlL0nOtlKLRKM=
Received: from mail-yw1-f69.google.com (mail-yw1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-k6NqzZ-wMTG18-dU-mkeXA-1; Sun, 17 Nov 2019 11:29:31 -0500
Received: by mail-yw1-f69.google.com with SMTP id k68so10951341ywe.14
        for <linux-cifs@vger.kernel.org>; Sun, 17 Nov 2019 08:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EE3R6siKevHye/Jm7O0FtPIp8FrQX681RaGaiU4xDPk=;
        b=HJZ9VnLENmU2sB1JEzqf7u+7j4/lo+LgkuIJEQzzfFebQz8/TaFkmM0OaDYQ1IeRVD
         9qLEuJWBKQJW10w2dBBSbPH6FVyg17G37RjmjNNxW20JyDjcTcuIF53UuKCt9OTeo4Yg
         1ClBj9kTEoB2EIs4UT2rZTAZIYmaSrDF3shZcV5uKZhRDHWsMkapem8vn0A9x4pjKFqU
         vIHXZ2/e5iXogpAw1bOsyqyZn4JGkA2za8rE9z9JAYhg2W1HWxSbw/dzscetY37yZIIi
         u8QWP/WahO2plWHDnIFIdo0UNuRnZEVtxz8Y0QcAcUGuXMjjq0+C7hcp6beTxM7UpBn8
         b+bQ==
X-Gm-Message-State: APjAAAXVyOENStkC5P6448yIMhpZFNn+auFFKKIqX+wOpuPALfwfuRO3
        5ttshywuquo/44KaNA1L6+MrkhduCej9AOoJxNy6E7khgqxGOyM+YIsa/wCcEglx/jtdLjU1a5k
        PZe6xZ7RHsWeKhZP/vP+vZw==
X-Received: by 2002:a25:c104:: with SMTP id r4mr19271315ybf.283.1574008170050;
        Sun, 17 Nov 2019 08:29:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqy7AiaNdcnIiZHL6MhVIPwHuwjgIthBtn9H2IEn27VBopsDJp3Gqe49UeQiGWov6SSojZ7yDQ==
X-Received: by 2002:a25:c104:: with SMTP id r4mr19271298ybf.283.1574008169687;
        Sun, 17 Nov 2019 08:29:29 -0800 (PST)
Received: from hut.sorensonfamily.com (198-0-247-150-static.hfc.comcastbusiness.net. [198.0.247.150])
        by smtp.gmail.com with ESMTPSA id y204sm5732399ywg.67.2019.11.17.08.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Nov 2019 08:29:29 -0800 (PST)
Subject: Re: A process killed while opening a file can result in leaked open
 handle on the server
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com>
 <CAKywueQ4nx2=V889Ty40QZOfoVij7Wp4dmhuhHV4A6mhGpgYAA@mail.gmail.com>
 <579288007.11441637.1573622351338.JavaMail.zimbra@redhat.com>
 <81694688.11451093.1573627786969.JavaMail.zimbra@redhat.com>
 <9195bac2-e271-537b-e1a0-8736efc80771@redhat.com>
 <1468784979.11678511.1573695584530.JavaMail.zimbra@redhat.com>
From:   Frank Sorenson <sorenson@redhat.com>
Message-ID: <03640853-6710-00b9-735d-75acd947109f@redhat.com>
Date:   Sun, 17 Nov 2019 10:29:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1468784979.11678511.1573695584530.JavaMail.zimbra@redhat.com>
Content-Language: en-US
X-MC-Unique: k6NqzZ-wMTG18-dU-mkeXA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 11/13/19 7:39 PM, Ronnie Sahlberg wrote:
> ----- Original Message -----
>> From: "Frank Sorenson" <sorenson@redhat.com>
>> To: "Ronnie Sahlberg" <lsahlber@redhat.com>, "Pavel Shilovsky" <piastryy=
y@gmail.com>
>> Cc: "linux-cifs" <linux-cifs@vger.kernel.org>
>> Sent: Thursday, 14 November, 2019 8:15:46 AM
>> Subject: Re: A process killed while opening a file can result in leaked =
open handle on the server
>>
>> On 11/13/19 12:49 AM, Ronnie Sahlberg wrote:
>>> Steve, Pavel
>>>
>>> This patch goes ontop of Pavels patch.
>>> Maybe it should be merged with Pavels patch since his patch changes fro=
m
>>> "we only send a close() on an interrupted open()"
>>> to now "we send a close() on either interrupted open() or interrupted
>>> close()" so both comments as well as log messages are updates.
>>>
>>> Additionally it adds logging of the MID that failed in the case of an
>>> interrupted Open() so that it is easy to find it in wireshark
>>> and check whether that smb2 file handle was indeed handles by a SMB_Clo=
se()
>>> or not.
>>>
>>>
>>> From testing it appears Pavels patch works. When the close() is interru=
pted
>>> we don't leak handles as far as I can tell.
>>> We do have a leak in the Open() case though and it seems that eventhoug=
h we
>>> set things up and flags the MID to be cancelled we actually never end u=
p
>>> calling smb2_cancelled_close_fid() and thus we never send a SMB2_Close(=
).
>>> I haven't found the root cause yet but I suspect we mess up mid flags o=
r
>>> state somewhere.
>>>
>>>
>>> It did work in the past though when Sachin provided the initial
>>> implementation so we have regressed I think.
>>> I have added a new test 'cifs/102'  to the buildbot that checks for thi=
s
>>> but have not integrated into the cifs-testing run yet since we still fa=
il
>>> this test.
>>> At least we will not have further regressions once we fix this and enab=
le
>>> the test in the future.
>>>
>>> ronnie s
>>
>> The patches do indeed improve it significantly.
>>
>> I'm still seeing some leak as well, and I'm removing ratelimiting so
>> that I can see what the added debugging is trying to tell us.  I'll
>> report if I find more details.

> We are making progress.

Agreed.  We're definitely making progress.

> Can you test this patch if it improves even more for you?
> It fixes most but not all the leaks I see for interrupted open():
>=20
> I will post this to the list too as a separate mail/patch.


Sorry to be slow on the testing.


I might be seeing some small improvement with this one, but I'm still seein=
g some mismatches:

# for i in {1..100} ; do cat /mnt/vm3/foo.$i >/dev/null 2>&1 & sleep 0.0001=
 ; kill -9 $! ; done
...

This ended up with 2 open on the server side:

21842        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)       =
/home/user1   foo.32   Sun Nov 17 09:13:38 2019
21842        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)       =
/home/user1   foo.48   Sun Nov 17 09:13:38 2019


the packet capture shows the same mismatch pattern for these two:

102  Create Request File: foo.32;GetInfo Request FILE_INFO/SMB2_FILE_ALL_IN=
FO;Close Request=20
103  Create Response File: foo.32;GetInfo Response;Close Response=20
104  Create Request File: foo.32=20
105  Create Response File: foo.32=20


148  Create Request File: foo.48;GetInfo Request FILE_INFO/SMB2_FILE_ALL_IN=
FO;Close Request=20
149  Create Response File: foo.48;GetInfo Response;Close Response=20
150  Create Request File: foo.48=20
151  Create Response File: foo.48=20

with no close for those two.


the messages are also similar, and show transmitting the second open reques=
t and cancelling the wait immediately afterward:
[9006] cifs:cifs_lookup:669: fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid=
: 1091 with uid: 0
[9006] cifs:cifs_lookup:672: fs/cifs/dir.c: parent inode =3D 0x000000008f94=
24fe name is: foo.32 and dentry =3D 0x0000000053e436bf
[9006] cifs:build_path_from_dentry_optional_prefix:143: fs/cifs/dir.c: name=
: \foo.32
[9006] cifs:cifs_lookup:704: fs/cifs/dir.c: NULL inode in lookup
[9006] cifs:cifs_lookup:707: fs/cifs/dir.c: Full path: \foo.32 inode =3D 0x=
000000004667ea0b
[9006] cifs:cifs_get_inode_info:753: fs/cifs/inode.c: Getting info on \foo.=
32
[9006] cifs:__smb_send_rqst:368: fs/cifs/transport.c: Sending smb: smb_len=
=3D356
[9006] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_re=
sult: cmd=3D5 mid=3D113 state=3D4
[9006] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_re=
sult: cmd=3D16 mid=3D114 state=3D4
[9006] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_re=
sult: cmd=3D6 mid=3D115 state=3D4
[9006] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passed =
to cifs_small_buf_release
[9006] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passed =
to cifs_small_buf_release
[9006] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passed =
to cifs_small_buf_release
[9006] cifs:cifs_iget:1030: fs/cifs/inode.c: looking for uniqueid=3D5934909
[9006] cifs:cifs_revalidate_cache:100: fs/cifs/inode.c: cifs_revalidate_cac=
he: revalidating inode 5934909
[9006] cifs:cifs_revalidate_cache:124: fs/cifs/inode.c: cifs_revalidate_cac=
he: invalidating inode 5934909 mapping
[9006] cifs:cifs_lookup:734: fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (=
xid =3D 1091) rc =3D 0
[9006] cifs:cifs_open:512: fs/cifs/file.c: CIFS VFS: in cifs_open as Xid: 1=
092 with uid: 0
[9006] cifs:build_path_from_dentry_optional_prefix:143: fs/cifs/dir.c: name=
: \foo.32
[9006] cifs:cifs_open:530: fs/cifs/file.c: inode =3D 0x000000001a16a2ae fil=
e flags are 0x8000 for \foo.32
[9006] cifs:SMB2_open:2581: fs/cifs/smb2pdu.c: create/open
[9006] cifs:__smb_send_rqst:368: fs/cifs/transport.c: Sending smb: smb_len=
=3D284
CIFS VFS: \\vm3 Cancelling wait for mid 116 cmd: 5
[9006] cifs:cifs_open:618: fs/cifs/file.c: CIFS VFS: leaving cifs_open (xid=
 =3D 1092) rc =3D -512



[9039] cifs:cifs_lookup:669: fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid=
: 1109 with uid: 0
[9039] cifs:cifs_lookup:672: fs/cifs/dir.c: parent inode =3D 0x000000008f94=
24fe name is: foo.48 and dentry =3D 0x0000000040aea0d9
[9039] cifs:build_path_from_dentry_optional_prefix:143: fs/cifs/dir.c: name=
: \foo.48
[9039] cifs:cifs_lookup:704: fs/cifs/dir.c: NULL inode in lookup
[9039] cifs:cifs_lookup:707: fs/cifs/dir.c: Full path: \foo.48 inode =3D 0x=
000000004667ea0b
[9039] cifs:cifs_get_inode_info:753: fs/cifs/inode.c: Getting info on \foo.=
48
[9039] cifs:__smb_send_rqst:368: fs/cifs/transport.c: Sending smb: smb_len=
=3D356
[9039] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_re=
sult: cmd=3D5 mid=3D158 state=3D4
[9039] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_re=
sult: cmd=3D16 mid=3D159 state=3D4
[9039] cifs:cifs_sync_mid_result:859: fs/cifs/transport.c: cifs_sync_mid_re=
sult: cmd=3D6 mid=3D160 state=3D4
[9039] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passed =
to cifs_small_buf_release
[9039] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passed =
to cifs_small_buf_release
[9039] cifs:cifs_small_buf_release:222: fs/cifs/misc.c: Null buffer passed =
to cifs_small_buf_release
[9039] cifs:cifs_iget:1030: fs/cifs/inode.c: looking for uniqueid=3D2185748=
8
[9039] cifs:cifs_revalidate_cache:100: fs/cifs/inode.c: cifs_revalidate_cac=
he: revalidating inode 21857488
[9039] cifs:cifs_revalidate_cache:124: fs/cifs/inode.c: cifs_revalidate_cac=
he: invalidating inode 21857488 mapping
[9039] cifs:cifs_lookup:734: fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (=
xid =3D 1109) rc =3D 0
[9039] cifs:cifs_open:512: fs/cifs/file.c: CIFS VFS: in cifs_open as Xid: 1=
110 with uid: 0
[9039] cifs:build_path_from_dentry_optional_prefix:143: fs/cifs/dir.c: name=
: \foo.48
[9039] cifs:cifs_open:530: fs/cifs/file.c: inode =3D 0x00000000001a4f79 fil=
e flags are 0x8000 for \foo.48
[9039] cifs:SMB2_open:2581: fs/cifs/smb2pdu.c: create/open
[9039] cifs:__smb_send_rqst:368: fs/cifs/transport.c: Sending smb: smb_len=
=3D284
CIFS VFS: \\vm3 Cancelling wait for mid 161 cmd: 5
[9039] cifs:cifs_open:618: fs/cifs/file.c: CIFS VFS: leaving cifs_open (xid=
 =3D 1110) rc =3D -512


Frank

