From: Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Subject: Re: Howto test a server is up.
Date: Fri, 11 Feb 2011 18:18:04 +0530
Message-ID: <4D553004.9000606@novell.com>
References: <AANLkTikZO_S+CFcAw_7FA3r5xG49CVT8f_XfVNBavajK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikZO_S+CFcAw_7FA3r5xG49CVT8f_XfVNBavajK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 02/11/2011 03:36 PM, Stef Bon wrote:
> Hi,
> 
> I've been searching for the way to test a smb server is ok.
> What is the way to do this??
> 

Sending an SMB echo? Look for patches from Jeff that recently added ECHO
call..


-- 
Suresh Jayaraman
