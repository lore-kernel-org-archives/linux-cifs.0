From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [cifs bindaddr v2] cifs: Allow binding to local IP address.
Date: Fri, 27 Aug 2010 12:52:42 -0400
Message-ID: <20100827125242.0798ffe9@tlielax.poochiereds.net>
References: <1282844096-13295-1-git-send-email-greearb@candelatech.com>
	<AANLkTik4Cffnr0ciYAVXz_jb_=EG5kBaKNE3V3cNVtwf@mail.gmail.com>
	<4C777615.2080109@erion.co.uk>
	<AANLkTi=9xBr2gABJSUSk2DMJEYho+jA3rbCk1PSfuQQ5@mail.gmail.com>
	<20100827095433.26bb3c3e@corrin.poochiereds.net>
	<4C77D9ED.4050101@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C77D9ED.4050101-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 Aug 2010 08:29:49 -0700
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:

> On 08/27/2010 06:54 AM, Jeff Layton wrote:
> 
> >> Also, I think bindaddr might not be the best name for the option. How
> >> about sourceaddr or srcaddr?
> >>
> >
> > Sounds reasonable.
> 
> It doesn't matter to me.  Please tell me which one you want me to use
> and I'll work on re-spinning this patch with ipv6 support.
> 
> Thanks,
> Ben
> 

My preference would be "srcaddr=".

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
