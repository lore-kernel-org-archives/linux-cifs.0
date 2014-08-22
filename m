From: Simo <simo@samba.org>
Subject: Re: Fwd: [PATCH 1/7] cifs: Bypass windows extended security for
 ntlmv2 negotiate
Date: Fri, 22 Aug 2014 08:30:08 -0400
Message-ID: <1408710608.11134.24.camel@pico.ipa.ssimo.org>
References: <003401cfbc62$f505f920$df11eb60$@samsung.com> <CAH2r5muT0jBfh_K230dtNW5ZkVFx+evHiDA=+yoeG_PvDkCxmA@mail.gmail.com> <1408674742.9485.78.camel@ruth.wgtn.cat-it.co.nz>
	<1408681047.11134.15.camel@pico.ipa.ssimo.org> <53F6ED6B.3010108@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <namjae.jeon@samsung.com>, Steve French <smfrench@gmail.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>, Andrew Bartlett <abartlet@samba.org>
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <53F6ED6B.3010108@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 2014-08-22 at 09:12 +0200, Stefan (metze) Metzmacher wrote:
> Am 22.08.2014 um 06:17 schrieb Simo:
> > On Fri, 2014-08-22 at 14:32 +1200, Andrew Bartlett wrote:
> >> On Wed, 2014-08-20 at 23:51 -0500, Steve French wrote:
> >>> This is an unusual sounding issue.  Any comments on this from the auth experts?
> >>>
> >>> Seems better to investigate this more if we end up enforcing a "must
> >>> be within 5 minutes" threshold instead of this patch.  Have we done a
> >>> dochelp on this before?
> >>
> >> I am certainly nervous about this patch, as I've not ever seen this
> >> before.  The thing that makes me feel particularly odd about this is
> >> that:  In general, NTLMSSP clients don't have the server's time,
> > 
> > This is simply false.
> > Modern servers send the server timestamp in the TargetInfo Av_Pair
> > structure in the challenge message [see MS-NLMP 2.2.2.1].
> > 
> > In [MS-NLMP 3.1.5.1.2] it is explicitly mentioned that the client must
> > use the provided (from the server) timestamp if present or current time
> > if it is not.
> 
> I talks about the MsvAvTimestamp from CHALLENGE_MESSAGE.TargetInfo.Value
> not the timestamp from smb negprot.

Sure, the point is that the server *does* send a timestamp that the
client is supposed to use.

> I think it would make sense to skip the timestamp if the client doesn't
> find the server time in CHALLENGE_MESSAGE.TargetInfo.Value
> and notices that the local time isn't correct. E.g. the date is
> before the year 2000.

IT probably shouldn't use the timestamp at all if the challenge message
does not have it because it means the server doesn't know what to do
about it anyway.
However using the timestamp found in the smb packet is as good as
anything else, it won't hurt anything, unless the server has its time
completely off and relay the authentication to a DC while the client had
the clock right.

Simo.
