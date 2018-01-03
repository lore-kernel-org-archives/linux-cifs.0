From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning after merge of the cifs tree
Date: Thu, 4 Jan 2018 09:33:59 +1100
Message-ID: <20180104093359.4e012f2f@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Long Li <longli@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
To: Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi all,

After merging the cifs tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

In file included from include/linux/seqlock.h:36:0,
                 from include/linux/time.h:6,
                 from include/linux/stat.h:19,
                 from include/linux/module.h:10,
                 from fs/cifs/smbdirect.c:16:
fs/cifs/smbdirect.c: In function 'smbd_recv_buf':
include/linux/spinlock.h:260:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
   _raw_spin_unlock_irqrestore(lock, flags); \
   ^
fs/cifs/smbdirect.c:1865:16: note: 'flags' was declared here
  unsigned long flags;
                ^

Introduced by commit

  ac69f66e54ca ("CIFS: SMBD: Implement function to receive data via RDMA receive")

OK, this is a false positive, but annoying.

I am using gcc 5.2.0.

-- 
Cheers,
Stephen Rothwell
