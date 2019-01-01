From: Yves-Alexis Perez <corsac@corsac.net>
Subject: Re: Stall during read() on CIFS with 4.19
Date: Tue, 01 Jan 2019 20:30:42 +0100
Message-ID: <7981cfaf015f9054490832d35ef99e992c000ab8.camel@corsac.net>
References: <80e6c45b77a512047ec59314a00b3199f9ca86fd.camel@corsac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org,
        Paulo Alcantara <palcantara@suse.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ronnie Sahlberg <lsahlber@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <80e6c45b77a512047ec59314a00b3199f9ca86fd.camel@corsac.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 2019-01-01 at 13:33 +0100, Yves-Alexis Perez wrote:
> Hi,
> 
> with the upgrade to 4.19 in Debian sid, I experienced a regression with CIFS
> filesystems.
> 
> The server is running Debian stretch with samba, the clients are running
> Debian sid or stretch. With 4.18 kernels everything is fine, but with 4.19
> while the mount succeeds, any read() syscall on a file open()ed from a share
> just stalls.

Hi all,

I'm doing a common reply following quick replies from Steve and Paul
(thanks!).

The bug is apparently fixed by 
https://marc.info/?l=linux-cifs&m=154629475812244&w=3 and also by mounting
with a rsize reduced to 16384.

Regards,
-- 
Yves-Alexis
