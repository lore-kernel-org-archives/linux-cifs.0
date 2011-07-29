From: "Christopher R. Hertel" <crh@ubiqx.mn.org>
Subject: Re: encryption on network
Date: Thu, 28 Jul 2011 19:08:04 -0500
Message-ID: <4E31F9E4.2030004@ubiqx.mn.org>
References: <06B0D589A4AC0243AD95D4DA4978081A182DE84D@mbx024-e1-nj-6.exch024.domain.local>
	<4E31E9DD.2060604@ubiqx.mn.org>
	<20110728235410.GA4976@jeremy-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>,
	Dominic Dougherty <dominic.dougherty@protegrity.com>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	linux-cifs@vger.kernel.org
To: Jeremy Allison <jra@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20110728235410.GA4976@jeremy-laptop>
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

Jeremy Allison wrote:
> On Thu, Jul 28, 2011 at 05:59:41PM -0500, Christopher R. Hertel wrote:
>> The network traffic is not encrypted.
>>
>> The SMB protocol does not provide any mechanism for encrypting traffic
>> between clients and servers.
> 
> As shipped by Microsoft :-). The UNIX extensions to SMB allow
> encrypted traffic between clients and servers and Samba has
> supported this for a long time (smbclient -e will encrypt
> traffic).

Right, but the question particularly listed WinXP as one of the
participating clients.  Windows clients don't support the Unix extensions,
so they don't support encrypted SMB and that kinda ruins the whole thing,
eh?  [sad face]

>> The only good way to ensure that the traffic
>> is encrypted is to create a VPN and ensure that SMB traffic is always
>> contained within the VPN.
> 
> Or use Samba smbclient to a smbd server :-). Of course, we
> really need this in the Linux CIFS client.

...and that's the other piece.  Smbclient is a very useful tool, but not
what you want to use if you are trying to mount a file system.

> Steve French - where's my encrypted transport code !!! (your
> monthly ping on this :-).

Please allow me to join the choir on that.  (I'll sit at the back and not
get in anyone's way.)  [winky face]

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
