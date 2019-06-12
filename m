Return-Path: <SRS0=Mq7t=UL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760AFC31E46
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jun 2019 16:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 480472082C
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jun 2019 16:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbfFLQTE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Jun 2019 12:19:04 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45458 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfFLQTD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Jun 2019 12:19:03 -0400
Received: by mail-pf1-f195.google.com with SMTP id s11so9927397pfm.12
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jun 2019 09:19:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZjdJe4gBZrPxnTp7SijcV/Guu3HhLfsYEucbCciiFYs=;
        b=m2UgA/A9Hda0Ezt2ZxQ9i83iA7B24AecyiojfDjw9Q21woGI8w4JE4mCv18gQAsFjV
         K9a2Zo2PjiyaPwk59H3d+Odh2IFL5IBdhNCVZ6OnMMrzIdTRVe9jIT4DljLGpJ/RQIxo
         delUJCw2jiNAntM3sEIDH/y2sVxTZdLrzB0NUA1tRBBZjkNFh40uPGJyfmhMKknI5Sr1
         fq69perdJz4x4tbm05XLN/BVo2XboeDKYgpjQgM9lCKSl0x6F1N+N35dIr5haykdujV2
         z/t/LjTn5UWgZtHGSjEqGoRUrIyhSxaW62bDvAv9iTcUuFzzyWafB8YU254m5aI7/PQw
         CC+A==
X-Gm-Message-State: APjAAAUkpceSHfZRBvv+O0xDBntUdEd7DOIvXljK7C8WKKvl8rYsdzfH
        Rgyu2yS2r7W4s2S7GkJxk1RkfpqE+K1zTI3DRgqmnw==
X-Google-Smtp-Source: APXvYqxqCEYTyAbNLSA9uPcB2GIGfeuC6PJvJPspUFGl+wc7JGq5B/OVJpHghBmO9pcsDiTgsOf6YC0J48w/i6Ke8Is=
X-Received: by 2002:a17:90a:1a0d:: with SMTP id 13mr27504881pjk.99.1560356342724;
 Wed, 12 Jun 2019 09:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <CALe0_75rQHY5em=YEvT-K64uOnWzAeg8p=ZZtH1WhEFzk4nNmg@mail.gmail.com>
 <CAH2r5muMo6LCEW1fTP4bGtf7aXggzs_YthRdB=qYnPg5EUEsJQ@mail.gmail.com>
 <20190123003029.GA235078@jra3> <20190124110829.GC20089@sernet.de>
 <20190124170341.GA104839@jra3> <20190124170945.wsasncusduwg3zbp@kazak>
 <CALe0_75-64OXgeWb6kQu6R1bA2OM9shJ=YQvbPnm6EJ_zHjbiQ@mail.gmail.com>
 <20190124201433.bibu3k2fo7h2bdep@kazak> <CALe0_74ZEDEafvyWqWqCD74TBO5Pyq=G=jb0AMcCmAwmP0OZYQ@mail.gmail.com>
 <20190124224927.GB252624@jra3>
In-Reply-To: <20190124224927.GB252624@jra3>
From:   Jacob Shivers <jshivers@redhat.com>
Date:   Wed, 12 Jun 2019 12:18:26 -0400
Message-ID: <CALe0_76rHGUedvRHvEyYvROPp8fPtvM9unkw7-gsLG2CPYxasw@mail.gmail.com>
Subject: Re: Fwd: SMB2 not respecting mtime values
To:     Jeremy Allison <jra@samba.org>
Cc:     =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I finally got around to making some time for this and I this is indeed
a server side issue.
The SMB client is using the appropriate file handles when setting
atime and mtime and the server initially reports the desired mtime.
The server only slightly later reports a mtime matching that of ctime.

$ tshark -tad -n -r cp_p-testing-3.16.66.pcap -Y 'smb2.pid == 0xf2d'
-T fields -e frame.number -e smb2.fid -e smb2.last_access.time -e
smb2.last_write.time -e _ws.col.Info -E header=y | tr '\t' '#' |
column -t -s '#'
frame.number  smb2.fid
smb2.last_access.time                smb2.last_write.time
   _ws.col.Info
170
                                                       Create Request
File: test_file-data
171
                                                       Create
Response, Error: STATUS_OBJECT_NAME_NOT_FOUND
173           00000000-0000-0000-0000-000000000000
                                                       Create Request
File: test_file-data
174           5981ad82-0000-0000-1d86-2dcf00000000  May 27, 2019
20:16:03.862513400 EDT  May 27, 2019 20:16:03.862513400 EDT  Create
Response File: test_file-data
175           5981ad82-0000-0000-1d86-2dcf00000000
                                                       GetInfo Request
FILE_INFO/SMB2_FILE_INTERNAL_INFO File: test_file-data
176
                                                       GetInfo
Response
177           5981ad82-0000-0000-1d86-2dcf00000000
                                                       Write Request
Len:12 Off:0 File: test_file-data
178
                                                       Write Response
179
                                                       Create Request
File: test_file-data
180           b8fa5b2d-0000-0000-d86e-38bf00000000  May 27, 2019
20:16:03.862513400 EDT  May 27, 2019 20:16:03.862513400 EDT  Create
Response File: test_file-data
181           b8fa5b2d-0000-0000-d86e-38bf00000000  Oct 31, 2018
00:00:00.000000000 EDT  Oct 31, 2018 00:00:00.000000000 EDT  SetInfo
Request FILE_INFO/SMB2_FILE_BASIC_INFO File: test_file-data
182
                                                       SetInfo
Response
183           b8fa5b2d-0000-0000-d86e-38bf00000000
                                                       Close Request
File: test_file-data
184                                                 Dec 31, 1969
19:00:00.000000000 EST  Dec 31, 1969 19:00:00.000000000 EST  Close
Response
185
                                                       Create Request
File: test_file-data
186           f7323833-0000-0000-5d04-6e1d00000000  Oct 31, 2018
00:00:00.000000000 EDT  Oct 31, 2018 00:00:00.000000000 EDT  Create
Response File: test_file-data
187           f7323833-0000-0000-5d04-6e1d00000000  Dec 31, 1969
19:00:00.000000000 EST  Dec 31, 1969 19:00:00.000000000 EST  SetInfo
Request FILE_INFO/SMB2_FILE_BASIC_INFO File: test_file-data
188
                                                       SetInfo
Response
189           f7323833-0000-0000-5d04-6e1d00000000
                                                       Close Request
File: test_file-data
190                                                 Dec 31, 1969
19:00:00.000000000 EST  Dec 31, 1969 19:00:00.000000000 EST  Close
Response
191           5981ad82-0000-0000-1d86-2dcf00000000
                                                       Close Request
File: test_file-data
192                                                 Dec 31, 1969
19:00:00.000000000 EST  Dec 31, 1969 19:00:00.000000000 EST  Close
Response


$ tshark -tad -n -r cp_p-testing-3.16.66.pcap -Y 'smb2.cmd == find' -O
smb2 | sed '/test_file-data/,/test_file-data/ !d'
            FileIdBothDirectoryInfo: test_file-data
                Next Offset: 0
                File Index: 0x00000000
                Create: May 27, 2019 20:16:03.862513400 EDT
                Last Access: Oct 31, 2018 00:00:00.000000000 EDT
                Last Write: May 27, 2019 20:16:03.872393500 EDT
                Last Change: May 27, 2019 20:16:03.872393500 EDT
                End Of File: 12
                Allocation Size: 1048576
                File Attributes: 0x00000020
                    .... .... .... .... .... .... .... ...0 = Read
Only: NOT read only
                    .... .... .... .... .... .... .... ..0. = Hidden: NOT hidden
                    .... .... .... .... .... .... .... .0.. = System:
NOT a system file/dir
                    .... .... .... .... .... .... .... 0... = Volume
ID: NOT a volume ID
                    .... .... .... .... .... .... ...0 .... =
Directory: NOT a directory
                    .... .... .... .... .... .... ..1. .... = Archive:
Modified since last ARCHIVE
                    .... .... .... .... .... .... .0.. .... = Device:
NOT a device
                    .... .... .... .... .... .... 0... .... = Normal:
Has some attribute set
                    .... .... .... .... .... ...0 .... .... =
Temporary: NOT a temporary file
                    .... .... .... .... .... ..0. .... .... = Sparse:
NOT a sparse file
                    .... .... .... .... .... .0.. .... .... = Reparse
Point: Does NOT have an associated reparse point
                    .... .... .... .... .... 0... .... .... =
Compressed: Uncompressed
                    .... .... .... .... ...0 .... .... .... = Offline: Online
                    .... .... .... .... ..0. .... .... .... = Content
Indexed: NOT content indexed
                    .... .... .... .... .0.. .... .... .... =
Encrypted: This is NOT an encrypted file
                Filename Length: 28
                EA Size: 60
                Reserved: 00000000
                File Id: 0x0000000000052b02
                Filename: test_file-data

I've added additional notes, strace, and pcap data to both kenel and
samba bugzillas that seem applicable to this:

  ** Bug 198967 - Modification times not preserved correctly **
  https://bugzilla.kernel.org/show_bug.cgi?id=198967

  ** Bug 13594 - smbd write time handling differs compared to recent
Windows releases **
  https://bugzilla.samba.org/show_bug.cgi?id=13594

The earlier comments about filehandle do not apply as the atime used
the same filehandle and the filehandle used is what should be used for
compound operations.

For context, Samba is matching behavior in Windows 2k16.


On Thu, Jan 24, 2019 at 5:49 PM Jeremy Allison <jra@samba.org> wrote:
>
> On Thu, Jan 24, 2019 at 05:47:24PM -0500, Jacob Shivers wrote:
> > On Thu, Jan 24, 2019 at 3:14 PM Ralph Böhme <slow@samba.org> wrote:
> > >
> > > On Thu, Jan 24, 2019 at 12:24:53PM -0500, Jacob Shivers wrote:
> > > >On Thu, Jan 24, 2019 at 12:11 PM Ralph Böhme via samba-technical
> > > ><samba-technical@lists.samba.org> wrote:
> > > >>
> > > >> On Thu, Jan 24, 2019 at 09:03:41AM -0800, Jeremy Allison via samba-technical wrote:
> > > >> >Maybe. Changing meta-data semantics on write is fraught with danger,
> > > >> >and we don't even do that for SMB1 unix extensions. So let's not
> > > >> >add contraints we don't understand yet please.
> > > >> >
> > > >> >My money is on a client bug, as always :-).
> > > >>
> > > >> fwiw, just in case you were not aware of this one:
> > > >>
> > > >> https://bugzilla.samba.org/show_bug.cgi?id=13594
> > > >>
> > > >> We also seem to have a bug that a set-eof on a handle with
> > > >> set-eof-size=existing-size doesn't flush a pending write time update. At least
> > > >> newer Windows server seem to do that.
> > > >
> > > >This seems like what the issue is.
> > > >The SMB server is uptime mtime after the server actually flushes to
> > > >stable storage.
> > >
> > > not quite, but still a client bug. :) The client uses a second handle to set the
> > > mtime, it should use the first handle. Or open the second handle after closing
> > > the first one where it did the write.
> >
> > Ahh.
> >
> > Thank you very much for your help and for narrowing down the problem
> > to a client side bug :)
>
> Bingo ! I claim my 5 euro :-) :-).
