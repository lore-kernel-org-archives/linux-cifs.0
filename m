From: Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: Overview of performance improvements of recent SMB3 compounding
 patches
Date: Wed, 22 Aug 2018 21:44:39 -0400 (EDT)
Message-ID: <1700708517.23372352.1534988679944.JavaMail.zimbra@redhat.com>
References: <CAH2r5mtO6545itRxAV0KW7NSt7ucvxgHOtg8wUZZ0DMHO-V8XQ@mail.gmail.com> <CAH2r5mt4Xd7Z86MSxFXNS___sJQjN5KJTH+XLXJcqT0=97wE9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mt4Xd7Z86MSxFXNS___sJQjN5KJTH+XLXJcqT0=97wE9A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

We also have stat() that drops from 6 to 2 roundtrips.

For metadata I think the only remaining low hanging fruit is readdir().
Currently in cifs.ko scanning a directory takes a minimum of 4 roundtrips :

open
query and get data
query and get the error STATUS_NO_MORE_FILES
close


For small-ish directories (the common case I expect will be that almost all directories will fit in one reply of data)
we can cut this down to just a single roundtrip by using the compound :

open; query; query; close

If the second query fails with the error above we know we are done and we finished in a single
roundtrip.

The drawback is for the rare cases where the directory did not fit in the reply, then
we will have to throw all the data away and re-start from scratch using the old loop thus making all large directory scans
even slower than they are right now, well just one roundtrip slower but still.
(Technically, the protocol does support re-opening a directory and resuming at a specific FileIndex  but it is not implemented server-side.)

I think it will still be worth it if we can get the common case to drop from 4 to 1 roundtrip.

It will involve touching cifs_readdir() which is hairy code but if someone would want to tackle this I think there is opportunity to make
a huge impact on directory listing performance.


regards
ronnie sahlberg




----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "CIFS" <linux-cifs@vger.kernel.org>, "samba-technical" <samba-technical@lists.samba.org>, "LKML"
> <linux-kernel@vger.kernel.org>, "linux-fsdevel" <linux-fsdevel@vger.kernel.org>, "ronnie sahlberg"
> <ronniesahlberg@gmail.com>
> Sent: Thursday, 23 August, 2018 5:28:01 AM
> Subject: Re: Overview of performance improvements of recent SMB3 compounding patches
> 
> Continuing the experiments with Ronnie's patches show additional
> promising performance results from other common scenarios:
> 
> Very good news that the number of roundtrips (request/response pairs
> to the server) has dropped so substantially.  Reducing latency, and
> allowing the server to more efficiently process the requests leads to
> much better performance for these common operations:
> 
> - rename goes from 9 request/response pairs to 5 ("mv /mnt/file /mnt/file1")
> - hardlink goes from 8 to only 3 (!)  ("ln /mnt/file1 /mnt/file2")
> - symlink (with mfsymlinks enabled) goes from 11 to 9 ("ln -s
> /mnt/file1 /mnt/file3")
> - touch (existing file) 6 down to 4
> 
> In current kernel we benefit from compounding now on stafs ("stat -f
> /mnt"), and in the earlier note I described the improvements in
> create, unlink, mkdir and rmdir which were also awesome.
> 
> This is very exciting.
> 
> On Tue, Aug 21, 2018 at 1:24 PM Steve French <smfrench@gmail.com> wrote:
> >
> > In experiments today with Ronnie's most recent compounding patches I
> > see the expected significant improvements in create/mkdir/unlink/rmdir
> > operations over SMB3 mounts (tests were to Samba but would be similar
> > to all modern servers).  See below:
> >
> > "touch /mnt/file"  goes from 6 request/response pairs to 4 with
> > Ronnie's compounding patches
> > "rm /mnt/file" from 5 to 2 request/response pairs
> > "mkdir /mnt/newdir" 6 pairs to 3 pairs
> > "rmdir /mnt/newdir" 6 pairs down to 2 pairs
> >
> > Good job Ronnie!
> > --
> > Thanks,
> >
> > Steve
> 
> 
> 
> --
> Thanks,
> 
> Steve
> 
