From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning after merge of the cifs tree
Date: Tue, 21 Nov 2017 10:19:16 +1100
Message-ID: <20171121101916.4970d5f9@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
To: Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/smb2pdu.c: In function 'SMB2_read':
fs/cifs/smb2pdu.c:2677:18: warning: unused variable 'rqst' [-Wunused-variable]
  struct smb_rqst rqst = { .rq_iov = iov,
                  ^

Introduced by commit

  889143494e16 ("cifs: remove rfc1002 header from smb2 read/write requests")

-- 
Cheers,
Stephen Rothwell
