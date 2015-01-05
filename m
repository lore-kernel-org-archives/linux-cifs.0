From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] Use memzero_explicit to clear local buffers
Date: Mon, 05 Jan 2015 18:36:48 +0100
Message-ID: <54AACBB0.8090007@redhat.com>
References: <1420394744-20268-1-git-send-email-me@mortis.eu> <20150104213538.GA19906@gondor.apana.org.au> <20150104224909.GB4806@salidar.dom.custoft.eu>
	<20150104233637.GA20757@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "open list:COMMON INTERNET F..." <linux-cifs@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Giel van Schijndel <me@mortis.eu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
	"moderated list:COMMON INTERNET F..." <samba-technical@lists.samba.org>, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
	Julia Lawall <Julia.Lawall@lip6.fr>, Thomas Pugliese <thomas.pugliese@gmail.com>, Ingo Molnar <mingo@redhat.com>, Rahul Bedarkar <rahulbedarkar89@gmail.com>,
	CRYPTO API <linux-crypto@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
	"open list:CERTIFIED WIRELES..." <linux-usb@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20150104233637.GA20757@gondor.apana.org.au>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On 01/05/2015 12:36 AM, Herbert Xu wrote:
...
> Daniel, we should add a comment so that people stop sending bogus
> patches with memzero_explicit.

I'll send a patch adding a comment, sure.

Thanks,
Daniel
