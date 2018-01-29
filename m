From: =?iso-8859-1?Q?Andr=E9s?= Souto <kai670@gmail.com>
Subject: Re: Fwd: [PATCH] cifs: add .splice_write
Date: Mon, 29 Jan 2018 11:47:07 +0100
Message-ID: <20180129104707.mlqg36xp2am5tfte@Dell-XPS-L322X>
References: <f29bddaa-62b5-046d-70f9-b809fd41a1d7@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f29bddaa-62b5-046d-70f9-b809fd41a1d7@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

I have been trying to reproduce it with a localhost samba and I wasn't
able to. I also tried adding delays and limiting bandwidth using tc
with the idea of replicating network delays of a gigabit ethernet
network but I didn't see a significant difference either.

So I investigate what is the difference between writing to the NAS
(where I discovered the problem) compared to the samba at localhost and
I see a completely different behaviour in the amount of data carried
by each SMB message.

 writing to NAS
 -----------------------------
 read/write 64kB         64kB
 read/write 1MB        1024kB
 splice 64kB            4096B
 splice 64kB (PATCH)     64kB
 splice 1MB (PATCH)    1024kB


 writing to localhost samba
 ---------------------------
 read/write 64kB         1MB
 splice 64kB             1MB
 splice 64kB (PATCH)     1MB

In every case, the server seems to send one ack SMB message for each
block of data and client doesn't sends new data until the ack is
received. I suppose this explains why the throughput is ridiculous
low for the situations when a SMB message carries so little data.
