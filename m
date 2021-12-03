Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B181C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Dec 2021 16:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhLCQlL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 11:41:11 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:33872 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382104AbhLCQlI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 11:41:08 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 70FF51FD3F;
        Fri,  3 Dec 2021 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638549463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8efOtvUhyHgKYQc0xc/hAJcs0V5q/XuxuY7JrLPylPE=;
        b=YWkgCAMzS1uRh9rFmOirq6ONpPdtH82ErXeO/qJB1x4PlQC+B7l0z7eEsfyENkz76XWlcW
        Kb94u6yBWkNrinGQVq2LTx6iL6GzZJ1Le1iyWA0f8N+S3YWEwwbJ0LcuJqteFTcDTHAHCM
        NIIRoiG5EJpl7A62rtiVfBKe8exHYcQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638549463;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8efOtvUhyHgKYQc0xc/hAJcs0V5q/XuxuY7JrLPylPE=;
        b=bdjDi6gLOY6xfrnujtbg7qBzMXJGciD3cUa79lWTLhHQh5ks4Ra0r7mPsv5xXz6psOVh4y
        3oyXkQcR12Udf/Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F20E013EC2;
        Fri,  3 Dec 2021 16:37:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lg+5LtZHqmHYOAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 03 Dec 2021 16:37:42 +0000
Date:   Fri, 3 Dec 2021 13:37:40 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
Message-ID: <20211203163740.ob64ykyg3mzisc7v@cyberdelia>
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia>
 <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
 <CA+_sParqF63m24NjL4o42agyk3mU_Cq1A-kpKFBpZaGmhdWYqg@mail.gmail.com>
 <20211201165728.r3jvaan2hw5icfvp@cyberdelia>
 <CA+_sPar2eifjAt_+gbLfdH9ns+YmWtQG3HhXVep5dx0=wqGs_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+_sPar2eifjAt_+gbLfdH9ns+YmWtQG3HhXVep5dx0=wqGs_w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 12/03, Sergey Senozhatsky wrote:
>Hello,
>
>On Thu, Dec 2, 2021 at 1:57 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>> > ...
>> > The intention is to make it more like other modern tools (e.g. git,
>> > nvme, virsh, etc) which have more clear user interface, readable
>> > commands, and also makes it easier to script.
>> >
>> > Example commands:
>> >   # ksmbdctl share add myshare -o "guest ok=yes, writable=yes, path=/mnt/data"
>> >   # ksmbdctl user add myuser
>> >   # ksmbdctl user add -i $HOME/mysmb.conf anotheruser
>> >   # ksmbdctl daemon start
>> >
>> > Besides adding a new "share list" command, any previously working
>> > functionality shouldn't be affected.
>>
>> - clearer user interface: having a single binary looks much clearer than
>>    having several separate programs when, e.g. the user is looking which
>>    program does what.
>>
>> - more readable commands: continuing from topic above, the situation is
>>    improved especially when you see that, e.g., the ksmbd.addshare program
>>    also updates and deletes shares. With this unification, it is way more
>>    intuitive to use:
>
>I've always preferred the UNIX way: one app does one thing and one thing only.
>This is why we have cp and mv, mkdir and touch, etc. we don't have a
>single vfs-ctl
>app that takes several hundred arguments and whose man page is basically a
>small book (20+ pages long). This way we:
>- keep manpages short and clear
>- avoid params conflicts and ambiguity
>- keep eggs in different baskets

Sure, I agree. Again, this could also be worked out in my proposal (I
haven't touched much besides README yet though).
For the missing stuff, e.g. manpages, we can also implement them the git
way, like "man 1 ksmbdctl" vs "man 1 ksmbdctl-share", where the former
would mention the latter, but only briefly and then indicate that a
sub-manpage exists for that command.

>> I ask you to consider the applications I used as inspiration for such change, such as git
>
> ... snip ...
>
>Built-in commands are, basically, independent binaris that have a
>common ancestor with the
>only exception that git does not fork/exec them (not all of them).
>They even have entry points
>that resemble main() - they take "int argc, const char **argv" - and
>git passes its argc and argv
>down to built-ins.
>
>Schematically
>
>git: main(int argc, char **argv) {
>      builtin = lookup_builtin_command();
>      builtin->run(argc, argv);
>}
>
>Is this what you have in mind?

Yes, I've implemented it exactly that way:

share/share_admin.h:
void share_usage(ksmbd_share_cmd cmd);
int share_cmd(int argc, char *argv[]);

user/user_admin.h:
void user_usage(ksmbd_user_cmd cmd);
int user_cmd(int argc, char *argv[]);

daemon/daemon.h:
void daemon_usage(ksmbd_daemon_cmd cmd);
int daemon_cmd(int argc, char *argv[]);

The *_usage() functions were something I was preparing to accomodate the
new command abstraction I mentioned earlier, but I still haven't got to
finish. I wanted to get this unification approved first.

>>   # ksmbdctl daemon start
>
>Is this going to fork ksmb daemon? Otherwise this looks confusing. I'd
>say that ksmbd daemon
>needs to have a different name that will clearly show that it's a ksmb
>daemon, not the "control"
>tool that adds shares and deletes users.

At daemon_process_start(), I did:

...
if(prctl(PR_SET_NAME, "ksmbd-daemon\0", 0, 0, 0);
	pr_info("Can't set program name: %s\n", strerr(errno));
...

which TBH I'm not sure is good enough. Alternatives/opinions are
welcome.


Cheers,

Enzo
