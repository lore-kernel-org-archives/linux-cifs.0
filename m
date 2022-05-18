Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2239DC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 03:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiERD4Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 May 2022 23:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiERD4Y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 May 2022 23:56:24 -0400
Received: from d.mail.sonic.net (d.mail.sonic.net [64.142.111.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD128B10
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 20:56:18 -0700 (PDT)
Received: from ocelot (157-131-248-104.fiber.dynamic.sonic.net [157.131.248.104])
        (authenticated bits=0)
        by d.mail.sonic.net (8.16.1/8.16.1) with ESMTPA id 24I3u9QW029006;
        Tue, 17 May 2022 20:56:09 -0700
From:   Forest <forestix@sonic.net>
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: getxattr() on cifs sometimes hangs since kernel 5.14
Date:   Tue, 17 May 2022 20:56:09 -0700
Message-ID: <jcr88hdgn3k3i12tcm4a74bcel2bf27o1m@4ax.com>
References: <91188ht5vqi7kq3ml5d3a48sjo9ltqjko3@4ax.com> <CAH2r5muJYFQ7FutNP_WWCHPE+dDSi6=_x27P81+FN7QGQKyzFA@mail.gmail.com>
In-Reply-To: <CAH2r5muJYFQ7FutNP_WWCHPE+dDSi6=_x27P81+FN7QGQKyzFA@mail.gmail.com>
X-Mailer: Forte Agent 3.3/32.846
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Sonic-CAuth: UmFuZG9tSVbzj2P6imEcvv37gcfZwTn+DMo2UY85au2lUkF8vRqjII+lRQHFNNdmdnkf1UU1QiCPXpNvdBbGh8iNpoFKA4BU
X-Sonic-ID: C;frnHc17W7BGh2Z0guulSsA== M;QBnOc17W7BGh2Z0guulSsA==
X-Sonic-Spam-Details: -2.1/5.0 by cerberusd
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

/*
Attempt to reproduce a cifs xattr problem from kernel commit 9e992755be8f.

When running on recent kernel versions, this system call on a cifs-mounted
file sometimes takes an unusually long time:

getxattr("/cifsmount/dir/image.jpg", "user.baloo.rating", NULL, 0)

The call normally returns in under 10 milliseconds, but on kernel 5.14+, it
sometimes takes over 30 seconds with no significant client or server load.

Discovered while using gwenview to browse 100+ 1.5 MiB images on a samba share
mounted via /etc/fstab. While quickly flipping through the images, the problem
often occurs within 20 seconds. Gwenview freezes until the call completes.

Client:
  kernel versions 5.14 and later
  mount.cifs 6.11
  Gwenview 20.12.3
  Debian Bullseye
  4-core amd64
Server:
  Samba 4.13.13-Debian
  Debian Bullseye
  6-core arm64 

A git bisect identified kernel commit 9e992755be8f as the problematic change.
The problem does not occur when any of the following are true:
- Client is running a kernel from before that commit.
- The nouser_xattr mount option is used on the cifs share.
- Gwenview accesses the files via smb:// URL instead of a cifs mount.

This program tries to reproduce the problem by making system calls seen in
strace output from a stuck gwenview instance. It expects its arguments to be
file paths on a cifs mount. It will loop over the named files, applying the
system calls to each one in sequence. The -i option is available to run
several iterations of the loop. For example, with -i 2 and 10 files, the system
calls will be made 20 times. This normally completes quickly.

The -t option runs the same loop in multiple threads, which seems to trigger
the problem: getxattr() takes over 100 times as long when more than one thread
is running.

Curiously, the call never seems to be as slow in this reproducer (~1 second) as
it sometimes is in gwenview (30+ seconds), so perhaps this code does not model
gwenview's triggering behavior well. Nevertheless, it reproduces a significant
delay under the same conditions, so it might still help track down the problem.

Build with:
gcc -pthread

*/

#include <alloca.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/xattr.h>
#include <unistd.h>


int test_file(char *path)
    {
    int fd;

    fd = openat(AT_FDCWD, path, O_RDONLY);
    if (fd == -1)
        {
        perror("openat");
        return -1;
        }
    close(fd);
    getxattr(path, "user.baloo.rating", NULL, 0); /* sometimes slow */

    return 0;
    }


int test_files(char **paths)
    {
    for (; *paths; paths++)
        if (test_file(*paths))
            return -1;
    return 0;
    }


int test_files_repeatedly(char **paths, int itercount)
    {
    while (itercount--)
        if (test_files(paths))
            return -1;
    return 0;
    }


struct thread_params
    {
    char **paths;
    int itercount;
    };


void *thread_main(void *thread_arg)
    {
    struct thread_params params = *(struct thread_params *)thread_arg;

    while (params.itercount--)
        if (test_files(params.paths))
            return "failure in test thread";

    return 0;
    }


int test_files_threaded(char **paths, int itercount, int threadcount)
    {
    struct thread_params params = {paths, itercount};
    pthread_t *threadids;
    int i;

    threadcount--; /* the main thread will do one thread's work */

    threadids = alloca(sizeof(*threadids) * threadcount);

    for (i = 0; i < threadcount; i++)
        if (pthread_create(&threadids[i], NULL, thread_main, &params))
            {
            printf("pthread_create failed\n");
            return -1;
            }

    /* do one thread's work in the main thread */
    if (test_files_repeatedly(paths, itercount))
        {
        printf("failure in main thread");
        return -1;
        }

    for (i = 0; i < threadcount; i++)
        {
        void *thread_result;
        if (pthread_join(threadids[i], &thread_result))
            {
            printf("pthread_join failed\n");
            return -1;
            }
        if (thread_result)
            {
            printf("%s\n", (char *)thread_result);
            return -1;
            }
        }

    return 0;
    }


void usage(const char *cmd)
    {
    printf("usage: %s [-i iterations] [-t threads] <files>\n", cmd);
    }


int main(int argc, char *argv[])
    {
    int itercount = 1, threadcount=1, opt;
    char **paths;

    while ((opt = getopt(argc, argv, "i:t:h")) != -1)
        {
        switch (opt)
            {
            case 'i':
                itercount = atoi(optarg);
                break;
            case 't':
                threadcount = atoi(optarg);
                break;
            default:
                usage(argv[0]);
                return 2;
            }
        }
    if (optind == argc)
        {
        usage(argv[0]);
        return 2;
        }
    paths = &argv[optind];

    return test_files_threaded(paths, itercount, threadcount);
    }
