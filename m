From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Problem with Samba re-share of a CIFS mount
Date: Tue, 11 Feb 2014 12:45:36 -0500
Message-ID: <20140211124536.5fdcb56f@tlielax.poochiereds.net>
References: <52F9EDA5.1020004@assyoma.it>
	<20140211103302.6d74b90d@tlielax.poochiereds.net>
	<52FA46D5.8020904@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52FA46D5.8020904-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Feb 2014 16:50:45 +0100
Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org> wrote:

> Hi Jeff,
> I had the same idea.
> 
> When mounting the CIFS directory, the problematic installations return 0 
> links for both dirs and files. On the other hand, the stock CentOS 
> installation return 1 or more links.
> 
> It puzzled me. Two questions:
> - anyone know the rationale behind this?

The rationale is that windows servers always send a NumberOfLinks value
of '0' for directories. We have a hack in place that went in around a
year ago to work around that for (arguably broken) applications that
try to infer something about an inode that has a zero st_nlink value.

> - how it is possible to work-around that with an unpatched kernel?
> 

There is no workaround. Either fix the application such that it doesn't
care or patch the kernel. I'll cc Jim since he did a fair bit of
looking at this several months ago.

In truth though, resharing a cifs mount is probably not a great
solution. It sounds like the kind of setup that's going to end up being
fraught with cache coherency problems...


> Thank you and regards.
> 
> On 02/11/2014 04:33 PM, Jeff Layton wrote:
> > On Tue, 11 Feb 2014 10:30:13 +0100
> > Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org> wrote:
> >
> >> Hi all,
> >> I have a strange problem trying to re-share, via Samba, a CIFS mount.
> >>
> >> Let first explain my network topology:
> >>
> >> Win2008R2 w/SMB share -> low speed link -> Linux Box -> WIN7 clients
> >>
> >> In short, a Win2008 R2 share is being accessed by some W7 clients over a
> >> slow (~8 Mb/s downstream, ~1 Mb/s upstream) ADSL link. To speed up read
> >> operation on the branch office, I thought to use a Linux Box with
> >> cachefilesd and a CONFIG_CIFS_FSCACHE enabled kernel. The Linux box will
> >> mount the Win2008R2 share and, thanks to cachefilesd, it will maintain
> >> an "hot cache" of the read data. This CIFS mount is then shared, via
> >> Samba, to the other client Win7 PCs.
> >>
> >> However, the problem is that when re-sharing the CIFS mount, the Win7
> >> clients often see the many directories inside the mount as a regular
> >> files, and not directories! In other words, if I have a directory "test"
> >> inside the mount, the client PC will see a _file_ called "test". When
> >> double-clicking on that "file", the Win7 client even ask to select the
> >> application to open it.
> >>
> >> The strange this is that this problem happen with some Linux kernel
> >> version, but not with others. These are my results:
> >>
> >> 1) Stock CentOS 6.5 x86-64 system (kernel 2.6.32-431.1.2.0.1, cifs-utils
> >> 4.8.1-19, samba 3.6.9-167): no problem here, but this kernel does not
> >> have CONFIG_CIFS_FSCACHE, so I can not use it for speeding up read access;
> >>
> >> 2) CentOS 6.5 x86-64 with ElRepo updates (kernel 3.10.28-1): here
> >> CONFIG_CIFS_FSCACHE is enabled, but I have the problem described above;
> >>
> >> 3) Debian 7 amd64 with latest updates (kernel 3.2.54-2, cifs-utils
> >> 2:5.5-1): CONFIG_CIFS_FSCACHE is enabled, problem happens;
> >>
> >> 4) Fedora 20 x86-64 (kernel 3.12.8-300, cifs-utils 6.3-1, samba
> >> 4.1.3-2): CONFIG_CIFS_FSCACHE is enabled and problem does _not_ happen,
> >> however this is a client distro and I am not so comfortable to put it
> >> into production.
> >>
> >> Anyone has any explanation of what is happening here?
> >> Regards.
> >>
> >
> > Most likely, the problem is that the cifs mount is returning an
> > st_nlink value of 0 for directories, and that confuses samba into
> > thinking that directories are files (I forget their rationale for this).
> >
> > More recent kernels have patches that make the client fake up st_nlink
> > values when the server sends 0 for a NumberOfLinks value.
> >
> 


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
