From: Andrew Bartlett <abartlet@samba.org>
Subject: Re: Fwd: [PATCH 1/7] cifs: Bypass windows extended security for
 ntlmv2 negotiate
Date: Fri, 22 Aug 2014 14:32:22 +1200
Message-ID: <1408674742.9485.78.camel@ruth.wgtn.cat-it.co.nz>
References: <003401cfbc62$f505f920$df11eb60$@samsung.com>
	 <CAH2r5muT0jBfh_K230dtNW5ZkVFx+evHiDA=+yoeG_PvDkCxmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <namjae.jeon@samsung.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5muT0jBfh_K230dtNW5ZkVFx+evHiDA=+yoeG_PvDkCxmA@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 2014-08-20 at 23:51 -0500, Steve French wrote:
> This is an unusual sounding issue.  Any comments on this from the auth experts?
> 
> Seems better to investigate this more if we end up enforcing a "must
> be within 5 minutes" threshold instead of this patch.  Have we done a
> dochelp on this before?

I am certainly nervous about this patch, as I've not ever seen this
before.  The thing that makes me feel particularly odd about this is
that:  In general, NTLMSSP clients don't have the server's time, and
certainly don't have the domain controller's time.  (That CIFS provides
this does not mean we should use it, NTLMSSP is a general protocol and
adding CIFS-specific hacks indicates we are understanding it wrong, in
my experience).  

BTW, the domain controller is the only element here that could check the
embedded time, but I'll grant that typically servers are better in sync
with each other than this embedded device might be. 

The 5 mins stuff probably refers to Kerberos, which does have such a
time limit.  I've never seen NTLMSSP fail against windows due to clock
skew. 

I would like to see much more investigation here before this is done,
because if you just trust the server's time and if you need to, to pass
a security check, you override that check.  We need to understand why it
is in place. 

Thanks,

Andrew Bartlett


-- 
Andrew Bartlett
http://samba.org/~abartlet/
Authentication Developer, Samba Team  http://samba.org
Samba Developer, Catalyst IT          http://catalyst.net.nz/services/samba
