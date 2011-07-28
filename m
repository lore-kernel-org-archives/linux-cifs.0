From: Jeremy Allison <jra@samba.org>
Subject: Re: encryption on network
Date: Thu, 28 Jul 2011 16:54:10 -0700
Message-ID: <20110728235410.GA4976@jeremy-laptop>
References: <06B0D589A4AC0243AD95D4DA4978081A182DE84D@mbx024-e1-nj-6.exch024.domain.local>
	<4E31E9DD.2060604@ubiqx.mn.org>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>,
	Dominic Dougherty <dominic.dougherty@protegrity.com>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	linux-cifs@vger.kernel.org
To: "Christopher R. Hertel" <crh@ubiqx.mn.org>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <4E31E9DD.2060604@ubiqx.mn.org>
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

On Thu, Jul 28, 2011 at 05:59:41PM -0500, Christopher R. Hertel wrote:
> The network traffic is not encrypted.
> 
> The SMB protocol does not provide any mechanism for encrypting traffic
> between clients and servers.

As shipped by Microsoft :-). The UNIX extensions to SMB allow
encrypted traffic between clients and servers and Samba has
supported this for a long time (smbclient -e will encrypt
traffic).

> The only good way to ensure that the traffic
> is encrypted is to create a VPN and ensure that SMB traffic is always
> contained within the VPN.

Or use Samba smbclient to a smbd server :-). Of course, we
really need this in the Linux CIFS client.

Steve French - where's my encrypted transport code !!! (your
monthly ping on this :-).

Jeremy.
