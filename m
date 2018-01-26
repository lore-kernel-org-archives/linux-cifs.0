From: Steve French <smfrench@gmail.com>
Subject: Fwd: [PATCH] cifs: add .splice_write
Date: Fri, 26 Jan 2018 15:25:18 -0600
Message-ID: <CAH2r5mvgTBdwBgsA4r0x7KiuLEzW2YeU4Hz+PUeYyvooMCSN4g@mail.gmail.com>
References: <20171228132308.5709-1-kai670@gmail.com> <20180126181320.hc3sz4hyrfytj5d2@Dell-XPS-L322X>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
To: Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        =?UTF-8?Q?Andr=C3=A9s_Souto?= <kai670@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180126181320.hc3sz4hyrfytj5d2@Dell-XPS-L322X>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The patch did look like it improves the performance of file copy from
Nautilus when I tried it, but would prefer experimenting tool where I
could measure the improvement more precisely.  Is there a good command
line tool which generates splice_write indirectly? As expected cp and
dd don't seem to be affected by this patch.

In looking back at the commit history, I noticed Jens's much older
commit from 2007 (5ffc4ef45b3b0a57872f631b4e4ceb8ace0d7496)  which
added the
callouts to splice_read and more recently Al's commit
8d0207652cbe27d1f962050737848e5ad4671958 which
introduced iter_file_splice_write a couple years ago (for cifs.ko he
updated via commit
3dae8750c368f8ac11c3c8c2a28f56dcee865c01 to add write_iter support).
Interesting that splice write wasn't
added to cifs.ko but it does seem to help in the case you describe
(Nautilus or other apps that use splice).

To localhost (Samba server, cifs.ko on client with default mount
options, current kernel rc9) on my laptop - my quick tests to showed >
500MB/sec performance with dd (1M block size), so will be curious what
splice syscall results in.

---------- Forwarded message ----------
From: Andr=C3=A9s Souto <kai670@gmail.com>
Date: Fri, Jan 26, 2018 at 12:13 PM
Subject: Re: [PATCH] cifs: add .splice_write
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org


I want to explain a bit what is the problem this patch solves.

Without it, I always obtain a transfer rate below 9MB/s when writing
to a cifs share using splice syscall independently of the buffer size
used. However, when reading from the cifs share, I obtain around 105
MB/s.

After applying the patch, the transfer rate I obtain writing to the
cifs share depending on the buffer size is:

blocksize (kB)| transfer rate (MB/s)
--------------+----------------------
           64 | 51.52
          128 | 65.41
          256 | 76.64
          512 | 85.72
         1024 | 90.21
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Thanks,

Steve
