From: "Christopher R. Hertel" <crh@ubiqx.mn.org>
Subject: Re: encryption on network
Date: Thu, 28 Jul 2011 19:26:48 -0500
Message-ID: <4E31FE48.7060606@ubiqx.mn.org>
References: <06B0D589A4AC0243AD95D4DA4978081A182DE84D@mbx024-e1-nj-6.exch024.domain.local>	<4E31E9DD.2060604@ubiqx.mn.org>	<20110728235410.GA4976@jeremy-laptop>	<4E31F9E4.2030004@ubiqx.mn.org>
	<20110729001133.GA6742@jeremy-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>,
	Dominic Dougherty <dominic.dougherty@protegrity.com>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	linux-cifs@vger.kernel.org
To: Jeremy Allison <jra@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20110729001133.GA6742@jeremy-laptop>
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
:
>> Right, but the question particularly listed WinXP as one of the
>> participating clients.  Windows clients don't support the Unix extensions,
>> so they don't support encrypted SMB and that kinda ruins the whole thing,
>> eh?  [sad face]
> 
> Yes I realize that. But that's not what you said. You said:
> "The SMB protocol does not provide any mechanism for encrypting traffic
> between clients and servers." - but that's not generically true,
> only between *Microsoft* clients and servers.

Well... technically the SMB protocol (as it exists today) is defined by the
Microsoft specifications, and they don't include any support for encryption.

There is, unfortunately, no "official" specification of the Unix extensions
for SMB (only an old draft that doesn't include encryption, IIRC).  Also, as
their name suggests, they're extensions to the protocol which means that
they're not part of the protocol itself.

> You made it sound like that was definitive, and you are the
> acknowledged authority on CIFS/SMB, so I couldn't let that
> stand. People link to your posts here :-).

Absolutely right to set the record straight.  I should have added the caveat
that the Unix extensions include support for encryption.

>> Please allow me to join the choir on that.  (I'll sit at the back and not
>> get in anyone's way.)  [winky face]
> 
> Maybe if we all wish REALLY HARD, Steve and Jeff will hear
> us.. :-).

Don't forget to click your heels together and burn the tana leaves when the
moon is full over Vermont.  ;)

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
