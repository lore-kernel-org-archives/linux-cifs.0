From: Simo <simo@samba.org>
Subject: Re: Fwd: [PATCH 1/7] cifs: Bypass windows extended security for
 ntlmv2 negotiate
Date: Fri, 22 Aug 2014 00:17:27 -0400
Message-ID: <1408681047.11134.15.camel@pico.ipa.ssimo.org>
References: <003401cfbc62$f505f920$df11eb60$@samsung.com> <CAH2r5muT0jBfh_K230dtNW5ZkVFx+evHiDA=+yoeG_PvDkCxmA@mail.gmail.com> <1408674742.9485.78.camel@ruth.wgtn.cat-it.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <namjae.jeon@samsung.com>, Steve French <smfrench@gmail.com>, samba-technical <samba-technical@lists.samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: Andrew Bartlett <abartlet@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1408674742.9485.78.camel@ruth.wgtn.cat-it.co.nz>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 2014-08-22 at 14:32 +1200, Andrew Bartlett wrote:
> On Wed, 2014-08-20 at 23:51 -0500, Steve French wrote:
> > This is an unusual sounding issue.  Any comments on this from the auth experts?
> > 
> > Seems better to investigate this more if we end up enforcing a "must
> > be within 5 minutes" threshold instead of this patch.  Have we done a
> > dochelp on this before?
> 
> I am certainly nervous about this patch, as I've not ever seen this
> before.  The thing that makes me feel particularly odd about this is
> that:  In general, NTLMSSP clients don't have the server's time,

This is simply false.
Modern servers send the server timestamp in the TargetInfo Av_Pair
structure in the challenge message [see MS-NLMP 2.2.2.1].

In [MS-NLMP 3.1.5.1.2] it is explicitly mentioned that the client must
use the provided (from the server) timestamp if present or current time
if it is not.

Not only a modern server *should* send a timestamp, but a modern client,
on seeing that a timestamp is available should provide a MIC in the
Authentication message [MS-NLMP 3.1.5.1.2].

Unfortunately samba at the moment has a very limited and incomplete
implementation of the NTLM protocol and doesn't do much with targetinfo
except mocking it up a little.

An implementation that is very close to implementing all of the MS-NLMP
specification is here:
https://git.samba.org/?p=idra/gss-ntlmssp.git;a=summary
or here: https://fedorahosted.org/gss-ntlmssp/
and I hope to make samba use it eventually, when we have a more decent
set of interfaces to connect to DCs (the current winbind interfacing is
suboptimal but fixable).

> and certainly don't have the domain controller's time.

This is true but not a problem today were servers are supposed to have
the time in sync with the KDC/Domain Controller anyway.

>   (That CIFS provides
> this does not mean we should use it, NTLMSSP is a general protocol and
> adding CIFS-specific hacks indicates we are understanding it wrong, in
> my experience).  
> 
> BTW, the domain controller is the only element here that could check the
> embedded time, but I'll grant that typically servers are better in sync
> with each other than this embedded device might be. 
> 
> The 5 mins stuff probably refers to Kerberos, which does have such a
> time limit.  I've never seen NTLMSSP fail against windows due to clock
> skew. 

That's becasue a client is supposed to use the time provided by the
server, so no clockskew is really possible,

> I would like to see much more investigation here before this is done,
> because if you just trust the server's time and if you need to, to pass
> a security check, you override that check.  We need to understand why it
> is in place. 

Sorry but this makes no sense, if you can bypass a "security mechanism"
in the client, then there is *no* security mechanism.

The reason why a timestamp is provided by the server is (most probably)
to mitigate replay attacks when the client uses a MIC (as it should)
when the timestamp is provided.

Simo.
