From: Steve French <smfrench@gmail.com>
Subject: Overview of performance improvements of recent SMB3 compounding patches
Date: Tue, 21 Aug 2018 13:24:17 -0500
Message-ID: <CAH2r5mtO6545itRxAV0KW7NSt7ucvxgHOtg8wUZZ0DMHO-V8XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

In experiments today with Ronnie's most recent compounding patches I
see the expected significant improvements in create/mkdir/unlink/rmdir
operations over SMB3 mounts (tests were to Samba but would be similar
to all modern servers).  See below:

"touch /mnt/file"  goes from 6 request/response pairs to 4 with
Ronnie's compounding patches
"rm /mnt/file" from 5 to 2 request/response pairs
"mkdir /mnt/newdir" 6 pairs to 3 pairs
"rmdir /mnt/newdir" 6 pairs down to 2 pairs

Good job Ronnie!
-- 
Thanks,

Steve
