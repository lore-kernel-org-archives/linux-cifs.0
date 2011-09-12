From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
	available
Date: Mon, 12 Sep 2011 11:01:58 +0200
Message-ID: <4E6DCA86.8020707@ts.fujitsu.com>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>	<1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>	<20110906121017.7ce0018b@tlielax.poochiereds.net>	<4E673D6F.90606@ts.fujitsu.com>	<20110907090321.2196de8f@tlielax.poochiereds.net>	<1315431768.22110.4.camel@obed>	<4E686D69.9090503@ts.fujitsu.com>	<1315467589.22110.55.camel@obed>	<4E68BACD.2020403@ts.fujitsu.com>	<1315486914.541.14.camel@obed>	<4E68BF73.2090707@ts.fujitsu.com>	<1315488187.541.16.camel@obed>	<4E68EEAE.2090102@ts.fujitsu.com>
	<20110909093736.082f0ea4@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	Martin Wilck <mwilck@arcor.de>, Andrew Bartlett <abartlet@samba.org>
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20110909093736.082f0ea4@corrin.poochiereds.net>
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

> For the record, I'm not 100% opposed to adding something like this as a
> workaround. What would probably be better would be a way for someone to
> specify the SPN in the mount options. The kernel could then pass that
> to the upcall and we wouldn't need to trust this string from the
> server. Admins would of course need to know what SPN to put in there
> however. Something like:
> 
>     -o spn=cifs/otherhostname.example.com

Sounds good. In our AD environment, an admin can do

ldapsearch "(cn=$COMPUTERNAME)" serviceprincipalname

to get the supported principal name(s).

Martin

-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany
Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://ts.fujitsu.com/imprint
