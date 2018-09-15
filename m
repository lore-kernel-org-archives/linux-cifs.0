From: Steve French <smfrench@gmail.com>
Subject: Re: [Patch v3 00/16] CIFS: add support for direct I/O
Date: Sat, 15 Sep 2018 04:28:09 -0500
Message-ID: <CAH2r5mtaV-avzB0Ygb7CidVoWaSXQ_5E8F5Ed1RQAyGue43jcw@mail.gmail.com>
References: <20180908021348.19956-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180908021348.19956-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

could you rebase these, patch 1 was merged quite a while ago, and
patch 2 etc. doesn't apply cleanly
On Fri, Sep 7, 2018 at 9:18 PM Long Li <longli@linuxonhyperv.com> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> This patch set implements direct I/O.
>
> In normal code path (even with cache=none), CIFS copies I/O data from
> user-space to kernel-space for security reasons of possible protocol
> required signing and encryption on user data.
>
> With this patch set, CIFS passes the I/O data directly from user-space
> buffer to the transport layer, when file system is mounted with
> "cache-none".
>
> Patch v2 addressed comments from Christoph Hellwig <hch@lst.de> and
> Tom Talpey <ttalpey@microsoft.com> to implement direct I/O for both
> socket and RDMA.
>
> Patch v3 added support for kernel AIO.
>
>
> Long Li (16):
>   CIFS: Add support for direct pages in rdata
>   CIFS: Use offset when reading pages
>   CIFS: Add support for direct pages in wdata
>   CIFS: pass page offset when issuing SMB write
>   CIFS: Calculate the correct request length based on page offset and
>     tail size
>   CIFS: Introduce helper function to get page offset and length in
>     smb_rqst
>   CIFS: When sending data on socket, pass the correct page offset
>   CIFS: SMBD: Support page offset in RDMA send
>   CIFS: SMBD: Support page offset in RDMA recv
>   CIFS: SMBD: Do not call ib_dereg_mr on invalidated memory registration
>   CIFS: SMBD: Support page offset in memory registration
>   CIFS: Pass page offset for calculating signature
>   CIFS: Pass page offset for encrypting
>   CIFS: Add support for direct I/O read
>   CIFS: Add support for direct I/O write
>   CIFS: Add direct I/O functions to file_operations
>
>  fs/cifs/cifsencrypt.c |   9 +-
>  fs/cifs/cifsfs.c      |  10 +-
>  fs/cifs/cifsfs.h      |   2 +
>  fs/cifs/cifsglob.h    |  11 +-
>  fs/cifs/cifsproto.h   |   9 +-
>  fs/cifs/cifssmb.c     |  19 +-
>  fs/cifs/connect.c     |   5 +-
>  fs/cifs/file.c        | 477 ++++++++++++++++++++++++++++++++++++++++++--------
>  fs/cifs/misc.c        |  17 ++
>  fs/cifs/smb2ops.c     |  22 ++-
>  fs/cifs/smb2pdu.c     |  20 ++-
>  fs/cifs/smbdirect.c   | 156 ++++++++++-------
>  fs/cifs/smbdirect.h   |   2 +-
>  fs/cifs/transport.c   |  34 ++--
>  14 files changed, 606 insertions(+), 187 deletions(-)
>
> --
> 2.7.4
>


-- 
Thanks,

Steve
