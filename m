From: simo <idra@samba.org>
Subject: Re: encryption on network
Date: Fri, 29 Jul 2011 09:25:37 -0400
Message-ID: <1311945937.4297.163.camel@pico.li.ssimo.org>
References: <06B0D589A4AC0243AD95D4DA4978081A182DE84D@mbx024-e1-nj-6.exch024.domain.local>
	<4E31E9DD.2060604@ubiqx.mn.org>	<20110728235410.GA4976@jeremy-laptop>
	<4E31F9E4.2030004@ubiqx.mn.org>	<20110729001133.GA6742@jeremy-laptop>
	<4E31FE48.7060606@ubiqx.mn.org>
	<CAH2r5muVFuCNwyAKK+O1s8M2LT5qCFYvYJ5XnxiqhqEDgW_NWQ@mail.gmail.com>
	<06B0D589A4AC0243AD95D4DA4978081A182DEC78@mbx024-e1-nj-6.exch024.domain.local>
	<4E321C18.5000201@ubiqx.mn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>,
	Dominic Dougherty <dominic.dougherty@protegrity.com>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	Jeremy Allison <jra@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: "Christopher R. Hertel" <crh@ubiqx.mn.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <4E321C18.5000201@ubiqx.mn.org>
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

On Thu, 2011-07-28 at 21:34 -0500, Christopher R. Hertel wrote:
> On 07/28/2011 09:11 PM, Dominic Dougherty wrote:

> > 2.) the newer version of samba supports SSL. However, the only valid client for this is smbclient.  Not support by the "net use" command.
> 
> This, as Jeremy so rightly pointed out, is based on the Unix extensions to SMB.

No, that's gssapi based encryption, we used to have support for SSL
encryption in the past (using a very nasty hack) but I think we removed
that support way back during the 3.0.x series.


-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo@samba.org>
Principal Software Engineer at Red Hat, Inc. <simo@redhat.com>
