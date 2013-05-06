From: Jeff Layton <jlayton@redhat.com>
Subject: Re: AES Crypto Support in Kernel
Date: Mon, 6 May 2013 10:22:45 -0400
Message-ID: <20130506102245.4f2036ca@tlielax.poochiereds.net>
References: <CAH2r5muCod5S7PgRgD6CEbSwFtXykUmyP8fusRqLt-KLW1cMvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org,
	samba-technical <samba-technical@lists.samba.org>,
	Shirish S Pargaonkar <shirishp@us.ibm.com>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5muCod5S7PgRgD6CEbSwFtXykUmyP8fusRqLt-KLW1cMvQ@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 6 May 2013 09:11:28 -0500
Steve French <smfrench@gmail.com> wrote:

> Shirish,
> Does the recent crypto merge to kernel, which includes these two
> patches for example, help you (at least on the more common chips,
> those with optimized AES offload support)?  Wonder if we can leverage
> the hardware offload in Samba?
> 

Doesn't samba use the NSS libs for this? If so, then they should
already be using the hardware offload since it does internally.

-- 
Jeff Layton <jlayton@redhat.com>
