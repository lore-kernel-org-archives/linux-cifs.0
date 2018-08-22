From: Steve French <smfrench@gmail.com>
Subject: Re: Overview of performance improvements of recent SMB3 compounding patches
Date: Wed, 22 Aug 2018 14:28:01 -0500
Message-ID: <CAH2r5mt4Xd7Z86MSxFXNS___sJQjN5KJTH+XLXJcqT0=97wE9A@mail.gmail.com>
References: <CAH2r5mtO6545itRxAV0KW7NSt7ucvxgHOtg8wUZZ0DMHO-V8XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mtO6545itRxAV0KW7NSt7ucvxgHOtg8wUZZ0DMHO-V8XQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Continuing the experiments with Ronnie's patches show additional
promising performance results from other common scenarios:

Very good news that the number of roundtrips (request/response pairs
to the server) has dropped so substantially.  Reducing latency, and
allowing the server to more efficiently process the requests leads to
much better performance for these common operations:

- rename goes from 9 request/response pairs to 5 ("mv /mnt/file /mnt/file1")
- hardlink goes from 8 to only 3 (!)  ("ln /mnt/file1 /mnt/file2")
- symlink (with mfsymlinks enabled) goes from 11 to 9 ("ln -s
/mnt/file1 /mnt/file3")
- touch (existing file) 6 down to 4

In current kernel we benefit from compounding now on stafs ("stat -f
/mnt"), and in the earlier note I described the improvements in
create, unlink, mkdir and rmdir which were also awesome.

This is very exciting.

On Tue, Aug 21, 2018 at 1:24 PM Steve French <smfrench@gmail.com> wrote:
>
> In experiments today with Ronnie's most recent compounding patches I
> see the expected significant improvements in create/mkdir/unlink/rmdir
> operations over SMB3 mounts (tests were to Samba but would be similar
> to all modern servers).  See below:
>
> "touch /mnt/file"  goes from 6 request/response pairs to 4 with
> Ronnie's compounding patches
> "rm /mnt/file" from 5 to 2 request/response pairs
> "mkdir /mnt/newdir" 6 pairs to 3 pairs
> "rmdir /mnt/newdir" 6 pairs down to 2 pairs
>
> Good job Ronnie!
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
