From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3] cifs: Add support of Alternate Data Streams
Date: Wed, 10 Oct 2012 15:59:15 -0700
Message-ID: <20121010225914.GA3795@jeremy-desktop>
References: <1349881906-9791-1-git-send-email-shirishpargaonkar@gmail.com>
 <20121010121435.124d9ce5@corrin.poochiereds.net>
 <CADT32eLA3+GpxLDJZq1MTAGLc2fRcQAo4=9G+FKw7HippkLc=w@mail.gmail.com>
 <20121010132559.0634822b@corrin.poochiereds.net>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121010132559.0634822b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 10, 2012 at 01:25:59PM -0400, Jeff Layton wrote:
> > 
> > Jeff, where does it say that a server should_not/does_not hand out
> > oplocks for an alternate data stream?
> > I have looked for such a documentation and have not found.
> > The one I read,
> >  http://msdn.microsoft.com/en-us/library/cc308443.aspx
> > does not mention/preclude alternate data streams from obtaining oplocks.
> > 
> 
> I believe Jeremy or Chris mentioned it when we were at SDC this year
> and I'm cc'ing them here. I don't recall where they said that was
> stated.

Hmmm. I don't remember saying that, but the smbtorture tests
will tell you for sure.

Jeremy.
