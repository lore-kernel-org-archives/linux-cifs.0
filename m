From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] sync_smb2_mid_result
Date: Sat, 12 Mar 2011 20:08:35 -0600
Message-ID: <AANLkTikE17b5J2rmNVh2NhFQgsvJzbj8BRWP4ifrThRu@mail.gmail.com>
References: <AANLkTinnLUXF3O=AOYG8PrCG1guAA8vkM18wYKSLegk2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinnLUXF3O=AOYG8PrCG1guAA8vkM18wYKSLegk2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

FYI - Had a minor typo in the previous version of this
(midState instead of mid_state) so made trivial change to
patch.  If bored, the updated patch is at ...

http://git.kernel.org/?p=linux/kernel/git/sfrench/cifs-2.6.git;a=commitdiff;h=4ed31c5451150f63fec609f46d083eaaaa5f2112

On Sat, Mar 12, 2011 at 7:55 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Previously CIFS added a function, sync_mid_result, to better handle
> certain error conditions.
> This patch adds the equivalent for SMB2 mids (they are used by smb2_sendrcv2
> which is added in the next patch)



-- 
Thanks,

Steve
