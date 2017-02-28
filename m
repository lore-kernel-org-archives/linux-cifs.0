From: Jeff Layton <jlayton@samba.org>
Subject: Re: [cifs-utils PATCH 0/8] cifs-utils: fix problems with credcaches
 with overridden process creds
Date: Tue, 28 Feb 2017 13:31:50 -0500
Message-ID: <1488306710.2613.2.camel@samba.org>
References: <20170224142750.4151-1-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: ssorce@redhat.com, samba-technical@lists.samba.org, cwseys@physics.wisc.edu
To: linux-cifs@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20170224142750.4151-1-jlayton@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

On Fri, 2017-02-24 at 09:27 -0500, Jeff Layton wrote:
> The main impetus for this set is patch #7, which is a one-liner. #8 may
> be overkill, but I do think that it's the right approach, at least for
> now.
> 
> In order to get all of this to build however, we need to eliminate the
> unsetenv override in replace.h, or add a test for unsetenv. I chose the
> former, so the real patches are preceded by a number of cleanup patches.
> 
> Jeff Layton (8):
>   data_blob: remove need for replace.h
>   spengo.c/asn1.c: remove need for replace.h
>   cifs.upcall: remove need for replace.h
>   replace.h: remove it
>   treewide: Eliminate SAFE_FREE
>   data_blob: Eliminate _PUBLIC_
>   cifs.upcall: unset $KRB5CCNAME when creating new credcache from keytab
>   cifs.upcall: don't do env scraping when uid is 0
> 
>  asn1.c           |   2 +-
>  cifs.upcall.8.in |   5 +-
>  cifs.upcall.c    |  56 +++--
>  configure.ac     |   2 +-
>  data_blob.c      |  11 +-
>  data_blob.h      |  10 +-
>  mount.cifs.c     |  16 +-
>  replace.h        | 674 -------------------------------------------------------
>  spnego.c         |   2 +-
>  9 files changed, 64 insertions(+), 714 deletions(-)
>  delete mode 100644 replace.h
> 

Chad messaged me privately and stated that these patches fixed the
issue he was having. Merged into cifs-utils master branch. This should
make v6.7.

Thanks!
