From: Steve French <smfrench@gmail.com>
Subject: Re: samba changing mode of files on rename
Date: Fri, 17 Sep 2010 12:27:54 -0500
Message-ID: <AANLkTikctbnerDjPa8HS0JuB0jGv2ACjtt8AQ97LFVP9@mail.gmail.com>
References: <20100917130005.23d0864a@corrin.poochiereds.net>
	<20100917131558.13a00c53@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20100917131558.13a00c53@corrin.poochiereds.net>
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

On Fri, Sep 17, 2010 at 12:15 PM, Jeff Layton <jlayton@samba.org> wrote:

> On Fri, 17 Sep 2010 13:00:05 -0400
> Jeff Layton <jlayton@samba.org> wrote:
>
> > I recently noticed a regression in samba in the last few weeks. Here's
> > a simple way to reproduce it:
> >
> > 1) use smbclient to put a file on a samba share
> > 2) change the mode of the file to something without the owner execute bit
> set
> > 3) rename the file using smbclient
> >
> > When you do this, the newly renamed file will magically end up with the
> > owner execute bit set. It seems like samba ought not be changing the
> > mode of files when renaming them so I consider this a regression.
> >
> > I've reported the bug in the Fedora BTS, and attached some info there.
> > Anyone more familiar with this code willing to have a look?
> >
> >     https://bugzilla.redhat.com/show_bug.cgi?id=617771
> >
> > I've was able to reproduce it today using the most recent samba version
> > available in the Fedora repos (3.5.5).
> >
> > Thanks,
>
> Volker pointed out a workaround on IRC...
>
> If I set "map archive = no" then this doesn't seem to happen. So, I
> guess something has happened relatively recently to make renames set
> the archive bit?


Interesting - but I would expect that rename would set the archive bit
(creates, file modifications also set the bit in Windows).  In Windows
rename sets the archive bit (although we don't need to track the archive bit
for Linux cifs.ko we probably could report it via xattrs for backup
applications to use - much like Windows backup apps check/clear it).

See below:

C:\Users\stevef>echo newfile > new

C:\Users\stevef>attrib new
A            C:\Users\stevef\new

C:\Users\stevef>attrib -a new

C:\Users\stevef>rename new newer

C:\Users\stevef>attrib newer
A            C:\Users\stevef\newer

-- 
Thanks,

Steve
