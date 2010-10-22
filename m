From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: git send-email [options] <file | directory | rev-list options >
Date: Fri, 22 Oct 2010 14:51:59 -0400
Message-ID: <20101022145159.12c401ae@tlielax.poochiereds.net>
References: <1287772348-29858-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287772348-29858-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Oct 2010 14:32:28 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

>   Composing:
>     --from                  <str>  * Email From:
>     --[no-]to               <str>  * Email To:
>     --[no-]cc               <str>  * Email Cc:
>     --[no-]bcc              <str>  * Email Bcc:
>     --subject               <str>  * Email "Subject:"
>     --in-reply-to           <str>  * Email "In-Reply-To:"
>     --annotate                     * Review each patch that will be sent in an editor.
>     --compose                      * Open an editor for introduction.
>     --8bit-encoding         <str>  * Encoding to assume 8bit mails if undeclared
> 
>   Sending:
>     --envelope-sender       <str>  * Email envelope sender.
>     --smtp-server       <str:int>  * Outgoing SMTP server to use. The port
>                                      is optional. Default 'localhost'.
>     --smtp-server-port      <int>  * Outgoing SMTP server port.
>     --smtp-user             <str>  * Username for SMTP-AUTH.
>     --smtp-pass             <str>  * Password for SMTP-AUTH; not necessary.
>     --smtp-encryption       <str>  * tls or ssl; anything else disables.
>     --smtp-ssl                     * Deprecated. Use '--smtp-encryption ssl'.
>     --smtp-domain           <str>  * The domain name sent to HELO/EHLO handshake
>     --smtp-debug            <0|1>  * Disable, enable Net::SMTP debug.
> 
>   Automating:
>     --identity              <str>  * Use the sendemail.<id> options.
>     --cc-cmd                <str>  * Email Cc: via `<str> $patch_path`
>     --suppress-cc           <str>  * author, self, sob, cc, cccmd, body, bodycc, all.
>     --[no-]signed-off-by-cc        * Send to Signed-off-by: addresses. Default on.
>     --[no-]suppress-from           * Send to self. Default off.
>     --[no-]chain-reply-to          * Chain In-Reply-To: fields. Default off.
>     --[no-]thread                  * Use In-Reply-To: field. Default on.
> 
>   Administering:
>     --confirm               <str>  * Confirm recipients before sending;
>                                      auto, cc, compose, always, or never.
>     --quiet                        * Output one line of info per email.
>     --dry-run                      * Don't actually send the emails.
>     --[no-]validate                * Perform patch sanity checks. Default on.
>     --[no-]format-patch            * understand any non optional arguments as
>                                      `git format-patch` ones.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Oops, sorry about that... git-send-email goof.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
